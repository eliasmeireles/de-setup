# K3s Cleanup Installation Script

This directory contains a script to install and configure an automated K3s cleanup system that helps maintain your K3s cluster by removing stopped containers and unused images.

## 📋 What it does

The installation script sets up:
- A cleanup script at `/usr/local/bin/k3s-cleanup.sh`
- A configurable cron job (default: daily at 2:00 AM)
- Logging to `/var/log/k3s-cleanup.log`
- Uses full path `/usr/local/bin/k3s` for cron compatibility

The cleanup process:
- ✅ Removes stopped containers (Created/Exited state)
- ✅ Removes unused images to free up disk space
- ✅ Shows disk usage before and after cleanup
- ✅ Logs all operations with timestamps

## 🚀 Quick Installation

### Direct execution with default schedule (2:00 AM daily)
```bash
curl -fsSL https://raw.githubusercontent.com/eliasmeireles/de-setup/refs/heads/main/k8s/install-k3s-cleanup.sh | sudo bash
```

### Direct execution with custom schedule
```bash
# Download and run with custom schedule (e.g., every 6 hours)
curl -fsSL https://raw.githubusercontent.com/eliasmeireles/de-setup/refs/heads/main/k8s/install-k3s-cleanup.sh | sudo bash -s -- '0 */6 * * *'
```

### Manual installation
```bash
# Download the script
wget https://raw.githubusercontent.com/eliasmeireles/de-setup/refs/heads/main/k8s/install-k3s-cleanup.sh

# Make it executable
chmod +x install-k3s-cleanup.sh

# Run with sudo (default schedule)
sudo ./install-k3s-cleanup.sh

# Or with custom schedule
sudo ./install-k3s-cleanup.sh '0 */6 * * *'
```

## 📋 Requirements

- **Root privileges**: The script must be run as root or with `sudo`
- **K3s installed**: The script requires K3s to be installed at `/usr/local/bin/k3s`
- **cron service**: For automated scheduling (usually pre-installed on most systems)

## 🔧 Usage

### After Installation

The script automatically sets up a daily cron job, but you can also run it manually:

```bash
# Run cleanup manually
sudo /usr/local/bin/k3s-cleanup.sh

# View cleanup logs
sudo tail -f /var/log/k3s-cleanup.log

# Check current cron jobs
crontab -l | grep k3s-cleanup
```

### Manual Cleanup Operations

If you need more control, you can use K3s crictl commands directly:

```bash
# List all containers
sudo k3s crictl ps -a

# Remove specific stopped containers
sudo k3s crictl rm <container-id>

# List all images
sudo k3s crictl images

# Remove unused images
sudo k3s crictl rmi --prune
```

## 📊 Monitoring

### Check Disk Usage
```bash
# Before cleanup
df -h | grep mnt

# View cleanup history
sudo grep "Disk usage" /var/log/k3s-cleanup.log
```

### View Logs
```bash
# View recent cleanup logs
sudo tail -20 /var/log/k3s-cleanup.log

# View all cleanup logs
sudo cat /var/log/k3s-cleanup.log

# Follow logs in real-time
sudo tail -f /var/log/k3s-cleanup.log
```

## ⚙️ Configuration

### Modify Cron Schedule

You can change the schedule by running the installation script again with a different cron schedule:

```bash
# Run the installation script with a new schedule
sudo ./install-k3s-cleanup.sh '0 */6 * * *'

# The script will:
# 1. Remove the existing crontab entry
# 2. Create a new entry with the updated schedule

# Schedule examples:
# '0 2 * * *'      # Daily at 2:00 AM (default)
# '0 */6 * * *'    # Every 6 hours
# '30 3 * * *'     # Daily at 3:30 AM
# '0 1 * * 0'      # Weekly on Sunday at 1:00 AM
# '0 3 1 * *'      # Monthly on 1st day at 3:00 AM
```

### Manual Crontab Edit

Alternatively, you can edit the crontab directly:

```bash
# Edit crontab
sudo crontab -e

# Modify the schedule in the k3s-cleanup entry
```

### Disable Automatic Cleanup

```bash
# Remove from crontab
sudo crontab -e
# Delete the line containing k3s-cleanup.sh
```

## 🔍 Troubleshooting

### Common Issues

**Script fails with "k3s command not found"**
```bash
# Check if k3s is installed at the expected location
ls -la /usr/local/bin/k3s

# If k3s is elsewhere, create a symlink
sudo ln -s $(which k3s) /usr/local/bin/k3s

# The script uses full path /usr/local/bin/k3s for cron compatibility
```

**Permission denied errors**
```bash
# Ensure script has correct permissions
sudo chmod +x /usr/local/bin/k3s-cleanup.sh

# Check file ownership
ls -la /usr/local/bin/k3s-cleanup.sh
```

**Cron job not running**
```bash
# Check if cron service is running
sudo systemctl status cron

# Start cron service if needed
sudo systemctl start cron
sudo systemctl enable cron
```

### Verification

```bash
# Test the cleanup script manually
sudo /usr/local/bin/k3s-cleanup.sh

# Check if cron job is scheduled
sudo crontab -l | grep k3s-cleanup

# Verify log file exists and is writable
ls -la /var/log/k3s-cleanup.log
```

## 🗑️ Uninstallation

To remove the cleanup system:

```bash
# Remove the script
sudo rm /usr/local/bin/k3s-cleanup.sh

# Remove from crontab
sudo crontab -e
# Delete lines containing k3s-cleanup

# Remove log file (optional)
sudo rm /var/log/k3s-cleanup.log
```

## 📝 Notes

- The script is designed to be safe and will only remove stopped containers and unused images
- All operations are logged with timestamps for audit purposes
- The script includes error handling and will exit safely if K3s is not available
- Disk usage is shown before and after cleanup to track space savings
- Uses full path `/usr/local/bin/k3s` to ensure cron jobs work correctly
- Re-running the installation script will replace the existing crontab entry with the new schedule

## 🤝 Contributing

Feel free to submit issues or pull requests to improve this script. The main repository is at: https://github.com/eliasmeireles/de-setup
