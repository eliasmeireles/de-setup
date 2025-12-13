# 🧩 K3s Installer

A smart and automated **K3s Kubernetes** installer for Linux systems (tested with Ubuntu).
This script automatically detects your network environment (VPN, Public IP, FQDN), installs K3s with secure defaults, and sets up your kubeconfig for immediate use.

---

## 📥 Installation

### **Option 1 — Manual download and run**

```bash
curl -fsSL https://eliasmeireles.com.br/tools/k8s/k3s-installer.sh -o k3s-installer.sh
chmod +x k3s-installer.sh
./k3s-installer.sh [options]
```

### **Option 2 — Run directly with `curl | bash`**

```bash
curl -fsSL https://eliasmeireles.com.br/tools/k8s/k3s-installer.sh | bash -s -- --cn my-cluster
```

---

## 🚀 Usage

The script supports multiple options for customization, though it tries to auto-detect most settings:

```bash
./k3s-installer.sh [--cn <name>] [--cip <ip>] [--vpn-if <iface>] [--pubip <ip>] [--cleanup] [--continue]
```

### Available Options

| Option       | Description                                                                 | Default |
| ------------ | --------------------------------------------------------------------------- | ------- |
| `--cn`       | Sets the cluster name (used in kubeconfig context).                         | `k8s-local` |
| `--cip`      | Sets the Cluster IP (Internal/VPN IP).                                      | Auto-detected (VPN > Hostname IP) |
| `--vpn-if`   | Sets the VPN interface name (e.g., `wt0`, `wg0`).                           | Auto-detected |
| `--pubip`    | Sets the Public IP (for external access).                                   | Auto-detected (Amazon CheckIP > Route) |
| `--path`     | Sets the data directory path.                                               | `/mnt/data` |
| `--cleanup`  | Uninstalls K3s and cleans up data directories.                              | *Optional* |
| `--continue` | Used with `--cleanup` to reinstall immediately after cleanup.               | *Optional* |
| `--help`     | Displays help and usage information.                                        | — |

---

## ⚙️ Examples

### 1. Smart Install (Auto-detect everything)

```bash
./k3s-installer.sh
```

### 2. Custom Cluster Name and Explicit VPN Interface

```bash
./k3s-installer.sh --cn dev-cluster --vpn-if wg0
```

### 3. Cleanup Existing Installation

```bash
./k3s-installer.sh --cleanup
```

### 4. Cleanup and Reinstall (Fresh Start)

```bash
./k3s-installer.sh --cleanup --continue
```

---

## 🧩 Features

1.  **Network Detection**:
    *   Automatically finds VPN interfaces (WireGuard, NetBird, etc.) to bind internal traffic.
    *   Detects Public IP for external access configuration (`node-external-ip`).
    *   Detects FQDN (via NetBird or hostname).

2.  **Secure Configuration**:
    *   Binds API Server and Advertiser to the Cluster/VPN IP.
    *   Adds FQDN, Public IP, and Localhost to TLS SANs for secure connectivity.

3.  **Kubeconfig Setup**:
    *   Automatically copies and permissions `~/.kube/config`.
    *   Updates the server URL to use the FQDN for remote access.
    *   Sets the context name to match your Cluster Name.

4.  **Verification**:
    *   Waits for the API server to be ready.
    *   Verifies node status.
    *   Provides commands to check certificate validity.

---

## 📋 Post-Install Checks

After installation, verify your cluster:

```bash
# Check nodes
kubectl get nodes -o wide

# Check certificate (from remote machine)
openssl s_client -connect <FQDN>:6443 2>/dev/null | openssl x509 -noout -text | grep DNS:
```