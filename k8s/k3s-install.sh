#!/usr/bin/env bash
set -euo pipefail

# ===============================================
# ⚙️ Default Config
# ===============================================
CLUSTER_NAME="k8s-local"
DATA_PATH="/mnt/data"
K3S_DATA_DIR="${DATA_PATH}/k3s"
K3S_CONFIG_FILE="/etc/rancher/k3s/config.yaml"
K3S_KUBECONFIG="/etc/rancher/k3s/k3s.yaml"
USER_KUBECONFIG="${HOME}/.kube/config"
VPN_IFACE=""
CLUSTER_IP=""
PUBLIC_IP=""
FQDN=""
CLEANUP=false
CONTINUE=false

# ===============================================
# 🧠 Parse Args
# ===============================================
while [[ $# -gt 0 ]]; do
  case "$1" in
    --cn) CLUSTER_NAME="$2"; shift 2 ;;
    --cip) CLUSTER_IP="$2"; shift 2 ;;
    --vpn-if) VPN_IFACE="$2"; shift 2 ;;
    --pubip) PUBLIC_IP="$2"; shift 2 ;;
    --path) DATA_PATH="$2"; K3S_DATA_DIR="${DATA_PATH}/k3s"; shift 2 ;;
    --cleanup) CLEANUP=true; shift ;;
    --continue) CONTINUE=true; shift ;;
    --help)
      echo "Usage: $0 [--cn name] [--cip ip] [--vpn-if iface] [--pubip ip] [--cleanup]"
      exit 0
      ;;
    *) shift ;;
  esac
done

# ===============================================
# 🧹 Cleanup
# ===============================================
if [[ "$CLEANUP" == true ]]; then
  echo "[INFO] Cleaning K3s..."
  sudo systemctl stop k3s || true
  [[ -f /usr/local/bin/k3s-uninstall.sh ]] && sudo bash /usr/local/bin/k3s-uninstall.sh || true
  sudo rm -rf "${K3S_DATA_DIR}" /var/lib/rancher/k3s /etc/rancher/k3s
  echo "[✅ DONE] Cleanup completed."
  if [[ "$CONTINUE" == false ]]; then
    exit 0
  fi
fi

# ===============================================
# 🌐 Detect Network
# ===============================================
echo "[INFO] Detecting network..."

# Try VPN iface + IP
if [[ -z "$VPN_IFACE" || -z "$CLUSTER_IP" ]]; then
  VPN_IFACE=$(ip -o link show | awk -F': ' '{print $2}' | grep -E 'wt|wg|netbird|vpn' | head -n1 || true)
  if [[ -n "$VPN_IFACE" ]]; then
    CLUSTER_IP=$(ip -4 -o addr show "$VPN_IFACE" | awk '{print $4}' | cut -d/ -f1)
    echo "[INFO] Found VPN interface: $VPN_IFACE ($CLUSTER_IP)"
  fi
fi

[[ -z "$CLUSTER_IP" ]] && CLUSTER_IP=$(hostname -I | awk '{print $1}')
[[ -z "$VPN_IFACE" ]] && VPN_IFACE="eth0"

FQDN=$(netbird status 2>/dev/null | grep "FQDN:" | awk '{print $2}' || true)
[[ -z "$FQDN" ]] && FQDN="$CLUSTER_IP"


if [[ -z "$PUBLIC_IP" ]]; then
  PUBLIC_IP=$(curl -s --max-time 5 https://checkip.amazonaws.com || true)
  [[ -z "$PUBLIC_IP" ]] && PUBLIC_IP=$(ip -4 route get 8.8.8.8 | grep -oP 'src \K[0-9.]+')
fi

echo "[INFO] Interface  : $VPN_IFACE"
echo "[INFO] Cluster IP : $CLUSTER_IP"
echo "[INFO] Public IP  : ${PUBLIC_IP:-N/A}"
echo "[INFO] FQDN       : $FQDN"

# ===============================================
# ⚙️ Generate Config File
# ===============================================
sudo mkdir -p "$(dirname "$K3S_CONFIG_FILE")"

sudo tee "$K3S_CONFIG_FILE" >/dev/null <<EOF
cluster-name: ${CLUSTER_NAME}
data-dir: ${K3S_DATA_DIR}
write-kubeconfig-mode: "0644"
bind-address: ${CLUSTER_IP}
advertise-address: ${CLUSTER_IP}
flannel-iface: ${VPN_IFACE}
tls-san:
  - ${FQDN}
  - ${CLUSTER_IP}
  - ${PUBLIC_IP:-${CLUSTER_IP}}
  - 127.0.0.1
EOF


# ===============================================
# 🚀 Install K3s
# ===============================================
echo "[INFO] Installing K3s..."

# Construct args securely
INSTALL_OPTS="server"
INSTALL_OPTS+=" --tls-san ${FQDN}"
INSTALL_OPTS+=" --tls-san ${CLUSTER_IP}"
INSTALL_OPTS+=" --tls-san ${PUBLIC_IP:-${CLUSTER_IP}}"
INSTALL_OPTS+=" --tls-san 127.0.0.1"
INSTALL_OPTS+=" --write-kubeconfig-mode 0644"
INSTALL_OPTS+=" --bind-address ${CLUSTER_IP}"
INSTALL_OPTS+=" --advertise-address ${CLUSTER_IP}"
INSTALL_OPTS+=" --flannel-iface ${VPN_IFACE}"

curl -sfL https://get.k3s.io | \
  INSTALL_K3S_EXEC="${INSTALL_OPTS}" \
  K3S_DATA_DIR="$K3S_DATA_DIR" \
  sh -

# ===============================================
# 🔁 Restart + Wait Ready
# ===============================================
sudo systemctl restart k3s
echo "[INFO] Waiting for API to respond..."
for i in {1..30}; do
  if curl -sk "https://${CLUSTER_IP}:6443/version" >/dev/null 2>&1; then
    echo "[✅] K3s API reachable via ${CLUSTER_IP}:6443"
    break
  fi
  sleep 3
done

# ===============================================
# 🧾 Update Kubeconfig
# ===============================================
sudo sed -i "s|https://.*:6443|https://${FQDN}:6443|g" "$K3S_KUBECONFIG"
sudo sed -i "s|default|${CLUSTER_NAME}|g" "$K3S_KUBECONFIG"
mkdir -p "$(dirname "$USER_KUBECONFIG")"
sudo cp "$K3S_KUBECONFIG" "$USER_KUBECONFIG"
sudo chown $(id -u):$(id -g) "$USER_KUBECONFIG"
sudo chmod 600 "$USER_KUBECONFIG"

# ===============================================
# ✅ Verify Cluster
# ===============================================
for i in {1..10}; do
  if kubectl get nodes >/dev/null 2>&1; then
    echo "[✅ SUCCESS] Cluster is online!"
    break
  fi
  echo "[WAIT] Retrying connection... ($i/10)"
  sleep 5
done

echo "--------------------------------------------"
echo "[✅ DONE] K3s installation completed!"
echo "Cluster : ${CLUSTER_NAME}"
echo "IP      : ${CLUSTER_IP}"
echo "FQDN    : ${FQDN}"
echo "VPN IF  : ${VPN_IFACE}"
echo "Public  : ${PUBLIC_IP:-N/A}"
echo "--------------------------------------------"
echo "To check the cluster, run:"
echo "kubectl get nodes -o wide"
echo "--------------------------------------------"
echo "To check the cluster, run:"
echo "openssl s_client -connect ${FQDN}:6443 2>/dev/null | openssl x509 -noout -text | grep DNS:"
echo "--------------------------------------------"
echo "To get kubectl config, run:"
echo "cat ${USER_KUBECONFIG}"
