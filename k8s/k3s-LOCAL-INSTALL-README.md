# 🧩 K3s Local install

A simple and automated **K3s Kubernetes** local install for Linux systems (tested with Ubuntu).
This script allows you to **quickly set up**, **manage**, and **optionally clean up** a local K3s cluster.

---

## 📥 Installation

You can run the script in **two ways** — either by downloading it manually or directly through `curl`.

### **Option 1 — Manual download and run**

```bash
curl -fsSL https://eliasmeireles.com.br/tools/k8s/k3s-local-install.sh -o k3s-local-install.sh
chmod +x k3s-local-install.sh
./k3s-local-install.sh [options]
```

### **Option 2 — Run directly with `curl | sudo bash`**

You can execute the install directly without saving it locally:

```bash
curl -fsSL https://eliasmeireles.com.br/tools/k8s/k3s-local-install.sh | sudo bash
```

You can also **pass arguments** directly to the script, for example:

```bash
curl -fsSL https://eliasmeireles.com.br/tools/k8s/k3s-local-install.sh | sudo bash -s -- --name my-cluster --path /opt/k3s
```

Or to remove everything (cleanup):

```bash
curl -fsSL https://eliasmeireles.com.br/tools/k8s/k3s-local-install.sh | sudo bash -s -- --cleanup
```

---

## 🚀 Usage

The script supports multiple options for flexibility:

```bash
./k3s-local-install.sh [--name <cluster-name>] [--path <data-path>] [--cleanup] [--help]
```

### Available Options

| Option      | Description                                                     | Default     |
| ----------- | --------------------------------------------------------------- | ----------- |
| `--name`    | Sets the cluster name.                                          | `k8s-local` |
| `--path`    | Sets the data directory path where cluster data will be stored. | `/mnt/data` |
| `--cleanup` | Removes K3s and deletes the data directory.                     | *Optional*  |
| `--help`    | Displays help and usage information.                            | —           |

---

## ⚙️ Examples

### 1. Install with default settings

```bash
./k3s-local-install.sh
```

**or**

```bash
curl -fsSL https://eliasmeireles.com.br/tools/k8s/k3s-local-install.sh | sudo bash
```

---

### 2. Install with custom name and path

```bash
./k3s-local-install.sh --name my-cluster --path /opt/k3s
```

**or**

```bash
curl -fsSL https://eliasmeireles.com.br/tools/k8s/k3s-local-install.sh | sudo bash -s -- --name my-cluster --path /opt/k3s
```

---

### 3. Clean up the environment

```bash
./k3s-local-install.sh --cleanup
```

**or**

```bash
curl -fsSL https://eliasmeireles.com.br/tools/k8s/k3s-local-install.sh | sudo bash -s -- --cleanup
```

This will:

* Run the K3s uninstall script.
* Remove the `/mnt/data/k3s` (or custom) directory completely.

> ⚠️ **Warning:** This action is irreversible — all cluster data and configurations will be deleted.

---

## 🧩 Requirements

* Linux (Ubuntu recommended)
* `curl` and `sudo` installed
* Internet connection for installation

---

## 🧰 What the Script Does

1. Validates command-line arguments.
2. Installs **K3s** if not already installed.
3. Configures the cluster using the provided `--name` and `--path`.
4. When `--cleanup` is provided:

   * Executes the K3s uninstall script.
   * Deletes the data directory (`/mnt/data/k3s` by default).
---