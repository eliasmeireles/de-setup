#!/usr/bin/env bash

set -euo pipefail

# ================================
# 🧩 DEFAULT CONFIGURATIONS
# ================================
CLUSTER_NAME="k8s-local"
CLUSTER_IP="127.0.0.1"
DATA_PATH="/mnt/data"
K3S_DATA_DIR="${DATA_PATH}/k3s"
K3S_CONFIG_FILE="/etc/rancher/k3s/config.yaml"
K3S_KUBECONFIG="/etc/rancher/k3s/k3s.yaml"
USER_KUBECONFIG="${HOME}/.kube/config"

# Optional IPs
VPN_IP=""
PUBLIC_IP=""

# ================================
# 📖 HELP FUNCTION
# ================================
show_help() {
  echo "Usage: $0 [OPTIONS]"
  echo
  echo "Options:"
  echo "  --cn <name>        Cluster name (default: k8s-local)"
  echo "  --cip <ip>         Cluster IP address (default: 127.0.0.1)"
  echo "  --vpn-ip <ip>      VPN IP address (Restricts API access to this IP)"
  echo "  --public-ip <ip>   Public IP address (For Ingress/ServiceLB advertising)"
  echo "  --path <path>      Base data path (default: /mnt/data)"
  echo "  --cleanup          Uninstall K3s and remove data directory"
  echo "  --help             Show this help message"
  echo
  echo "Examples:"
  echo "  $0 --cn dev-cluster --cip 192.168.1.10"
  echo "  $0 --vpn-ip 10.8.0.5 --public-ip 203.0.113.10"
  echo "  $0 --cleanup"
  exit 0
}

# ================================
# 🧠 PARSE ARGUMENTS
# ================================
CLEANUP=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --cn)
      CLUSTER_NAME="$2"
      shift 2
      ;;
    --cip)
      CLUSTER_IP="$2"
      shift 2
      ;;
    --vpn-ip)
      VPN_IP="$2"
      shift 2
      ;;
    --public-ip)
      PUBLIC_IP="$2"
      shift 2
      ;;
    --path)
      DATA_PATH="$2"
      K3S_DATA_DIR="${DATA_PATH}/k3s"
      shift 2
      ;;
    --cleanup)
      CLEANUP=true
      shift
      ;;
    --help)
      show_help
      ;;
    -*)
      echo "[ERROR] Unknown option: $1"
      echo "Use --help for usage information."
      exit 1
      ;;
    *)
      shift
      ;;
  esac
done

# ================================
# 🧹 CLEANUP (IF REQUESTED)
# ================================
if [[ "$CLEANUP" == true ]]; then
  echo "[INFO] Cleaning up K3s installation..."
  if [[ -f "/usr/local/bin/k3s-uninstall.sh" ]]; then
    sudo bash /usr/local/bin/k3s-uninstall.sh || true
  else
    echo "[WARN] Uninstall script not found, skipping..."
  fi

  echo "[INFO] Removing data directory: ${K3S_DATA_DIR}"
  sudo rm -rf "${K3S_DATA_DIR}"

  echo "[✅ DONE] Cleanup completed."
  exit 0
fi

# ================================
# 🔍 PREREQUISITES
# ================================
for cmd in curl base64; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "[ERROR] Command '$cmd' not found. Please install it before running this script."
    exit 1
  fi
done

# ================================
# 🧹 REMOVE EXISTING INSTALLATION
# ================================
echo "[INFO] Removing previous installation (if exists)..."
if [[ -f "/usr/local/bin/k3s-uninstall.sh" ]]; then
  sudo bash /usr/local/bin/k3s-uninstall.sh || true
fi

# ================================
# 📁 CREATE RESOURCE DIRECTORIES
# ================================
echo "[INFO] Creating resource directories..."
sudo mkdir -p "${DATA_PATH}/k8s-resources/"
sudo chmod -R 777 "${DATA_PATH}/k8s-resources/" || true

# ================================
# ⚙️ GENERATE K3S CONFIGURATION
# ================================
echo "[INFO] Creating K3s configuration file..."
sudo mkdir -p "$(dirname "$K3S_CONFIG_FILE")"

# Build K3s config content
cat <<EOF | sudo tee "$K3S_CONFIG_FILE" >/dev/null
cluster-name: ${CLUSTER_NAME}
data-dir: ${K3S_DATA_DIR}
write-kubeconfig-mode: "0644"
EOF

# ================================
# 🚀 INSTALL K3S
# ================================
echo "[INFO] Installing K3s..."

# Construct INSTALL_K3S_EXEC arguments
EXEC_ARGS=""

# Add default tls-san
EXEC_ARGS+=" --tls-san ${CLUSTER_IP}"

if [[ -n "$VPN_IP" ]]; then
  echo "[CONFIG] Restricting API server to VPN IP: $VPN_IP"
  EXEC_ARGS+=" --bind-address ${VPN_IP}"
  EXEC_ARGS+=" --node-ip ${VPN_IP}"
  EXEC_ARGS+=" --tls-san ${VPN_IP}"
fi

if [[ -n "$PUBLIC_IP" ]]; then
  echo "[CONFIG] Setting Node External IP: $PUBLIC_IP"
  EXEC_ARGS+=" --node-external-ip ${PUBLIC_IP}"
  EXEC_ARGS+=" --tls-san ${PUBLIC_IP}"
fi

# Debug: Show the configured arguments
echo "[DEBUG] K3s Exec Args: $EXEC_ARGS"

curl -sfL https://get.k3s.io | \
  K3S_DATA_DIR="$K3S_DATA_DIR" \
  INSTALL_K3S_EXEC="${EXEC_ARGS}" \
  sh -

# ================================
# 🧾 ENSURE KUBECONFIG IS AVAILABLE
# ================================
if [ ! -f "$K3S_KUBECONFIG" ]; then
  echo "[ERROR] K3s kubeconfig not found at $K3S_KUBECONFIG"
  exit 1
fi
sudo chmod 644 "$K3S_KUBECONFIG"

# ================================
# 🔀 FUNCTION: ADD K3S CONTEXT TO LOCAL KUBECONFIG
# ================================
add_k3s_context() {
  local name="$1"
  local src="$2"
  local dest="$3"

  local server ca cert key
  server=$(sudo kubectl --kubeconfig "$src" config view --raw -o jsonpath='{.clusters[0].cluster.server}')
  ca=$(sudo kubectl --kubeconfig "$src" config view --raw -o jsonpath='{.clusters[0].cluster.certificate-authority-data}')
  cert=$(sudo kubectl --kubeconfig "$src" config view --raw -o jsonpath='{.users[0].user.client-certificate-data}')
  key=$(sudo kubectl --kubeconfig "$src" config view --raw -o jsonpath='{.users[0].user.client-key-data}')

  mkdir -p "$(dirname "$dest")"
  touch "$dest"

  kubectl config set-cluster "${name}-cluster" \
    --server="$server" \
    --certificate-authority=<(echo "$ca" | base64 --decode) \
    --embed-certs=true \
    --kubeconfig="$dest"

  kubectl config set-credentials "${name}-user" \
    --client-certificate=<(echo "$cert" | base64 --decode) \
    --client-key=<(echo "$key" | base64 --decode) \
    --embed-certs=true \
    --kubeconfig="$dest"

  kubectl config set-context "$name" \
    --cluster="${name}-cluster" \
    --user="${name}-user" \
    --kubeconfig="$dest"

  kubectl config use-context "$name" --kubeconfig="$dest"

  echo "[OK] Context '$name' added to kubeconfig at '$dest'."
}

# ================================
# 🧩 EXECUTE CONTEXT ADDITION
# ================================
add_k3s_context "$CLUSTER_NAME" "$K3S_KUBECONFIG" "$USER_KUBECONFIG"

# ================================
# ✅ RESULT
# ================================
echo "[INFO] Available contexts:"
kubectl config get-contexts || true

echo "[✅ DONE] Installation and configuration completed."
echo "[INFO] Cluster Name: $CLUSTER_NAME"
echo "[INFO] Cluster IP: $CLUSTER_IP"
echo "[INFO] Data Path: $DATA_PATH"
