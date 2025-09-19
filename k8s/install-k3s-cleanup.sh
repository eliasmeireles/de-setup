#!/bin/bash

# K3s Cleanup Installation Script
# This script installs the k3s cleanup script and sets up crontab

set -e

echo "=== K3s Cleanup Installation Script ==="
echo "Timestamp: $(date)"
echo

# Check if running as root or with sudo
if [[ $EUID -ne 0 ]]; then
    echo "❌ This script must be run as root or with sudo"
    echo "Usage: sudo $0"
    exit 1
fi

# Create the cleanup script content
CLEANUP_SCRIPT_CONTENT='#!/bin/bash

# K3s Container and Image Cleanup Script
# This script removes stopped containers and unused images to free up disk space

set -e

echo "=== K3s Cleanup Script Started ==="
echo "Timestamp: $(date)"
echo

# Show disk usage before cleanup
echo "📊 Disk usage before cleanup:"
df -h | grep mnt
echo

# Check if k3s is running
if ! command -v k3s &> /dev/null; then
    echo "❌ Error: k3s command not found. Make sure k3s is installed and in PATH."
    exit 1
fi

# Function to cleanup containers
cleanup_containers() {
    echo "🧹 Checking for containers to cleanup..."
    
    # Get containers in Created or Exited state
    CONTAINERS_TO_REMOVE=$(k3s crictl ps -aq --state Created --state Exited 2>/dev/null || true)
    
    if [ -n "$CONTAINERS_TO_REMOVE" ]; then
        echo "Found containers to remove:"
        k3s crictl ps -a --state Created --state Exited 2>/dev/null || true
        echo
        
        echo "🗑️  Removing stopped containers..."
        echo "$CONTAINERS_TO_REMOVE" | xargs -r k3s crictl rm
        echo "✅ Containers removed successfully"
    else
        echo "✅ No stopped containers found to remove"
    fi
    echo
}

# Function to cleanup images
cleanup_images() {
    echo "🖼️  Removing unused images..."
    
    # Remove unused images
    if k3s crictl rmi --prune 2>/dev/null; then
        echo "✅ Unused images removed successfully"
    else
        echo "ℹ️  No unused images found or cleanup completed"
    fi
    echo
}

# Main cleanup process
echo "🚀 Starting cleanup process..."
echo

# Cleanup containers
cleanup_containers

# Cleanup images
cleanup_images

# Show disk usage after cleanup
echo "📊 Disk usage after cleanup:"
df -h | grep mnt
echo

echo "✅ K3s cleanup completed successfully!"
echo "Timestamp: $(date)"'

# Install the cleanup script
echo "📝 Installing k3s cleanup script to /usr/local/bin/k3s-cleanup.sh..."
echo "$CLEANUP_SCRIPT_CONTENT" > /usr/local/bin/k3s-cleanup.sh

# Make the script executable
echo "🔧 Setting executable permissions..."
chmod +x /usr/local/bin/k3s-cleanup.sh

# Create log directory if it doesn't exist
echo "📁 Creating log directory..."
mkdir -p /var/log
touch /var/log/k3s-cleanup.log

# Add crontab entry
echo "⏰ Adding crontab entry..."
CRON_ENTRY="0 2 * * * /usr/local/bin/k3s-cleanup.sh >> /var/log/k3s-cleanup.log 2>&1"

# Check if crontab entry already exists
if crontab -l 2>/dev/null | grep -q "k3s-cleanup"; then
    echo "ℹ️  Crontab entry for k3s-cleanup already exists, skipping..."
else
    # Add the cron job
    (crontab -l 2>/dev/null; echo "# k3s cleanup"; echo "$CRON_ENTRY") | crontab -
    echo "✅ Crontab entry added successfully"
fi

# Verify installation
echo
echo "🔍 Verifying installation..."
echo "Script location: /usr/local/bin/k3s-cleanup.sh"
ls -la /usr/local/bin/k3s-cleanup.sh

echo
echo "📅 Current crontab entries:"
crontab -l | grep -A1 -B1 "k3s-cleanup" || echo "No k3s-cleanup entries found"

echo
echo "✅ K3s cleanup installation completed successfully!"
echo "The script will run daily at 2:00 AM"
echo "Log file: /var/log/k3s-cleanup.log"
echo
echo "To test the script manually, run:"
echo "sudo /usr/local/bin/k3s-cleanup.sh"
