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
    echo "Usage: sudo $0 [-s cron_schedule] [-lk days]"
    echo "Example: sudo $0  # Use defaults (2:00 AM daily, 7 days retention)"
    echo "Example: sudo $0 -s '0 */6 * * *'  # Run every 6 hours"
    echo "Example: sudo $0 -lk 16  # Keep logs for 16 days"
    echo "Example: sudo $0 -s '0 */6 * * *' -lk 16  # Custom schedule and retention"
    exit 1
fi

# Default values
CRON_SCHEDULE="0 2 * * *"
LOG_KEEP_DAYS=7

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--schedule)
            CRON_SCHEDULE="$2"
            shift 2
            ;;
        -lk|--log-keep)
            LOG_KEEP_DAYS="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: sudo $0 [-s cron_schedule] [-lk days]"
            echo ""
            echo "Options:"
            echo "  -s, --schedule    Cron schedule (default: '0 2 * * *' - daily at 2:00 AM)"
            echo "  -lk, --log-keep   Days to keep logs (default: 7)"
            echo "  -h, --help        Show this help message"
            echo ""
            echo "Examples:"
            echo "  sudo $0"
            echo "  sudo $0 -s '0 */6 * * *'"
            echo "  sudo $0 -lk 16"
            echo "  sudo $0 -s '0 */6 * * *' -lk 16"
            exit 0
            ;;
        *)
            echo "❌ Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

echo "📅 Using cron schedule: $CRON_SCHEDULE"
echo "📦 Log retention: $LOG_KEEP_DAYS days"

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
if ! command -v /usr/local/bin/k3s &> /dev/null; then
    echo "❌ Error: k3s command not found. Make sure k3s is installed at /usr/local/bin/k3s."
    exit 1
fi

# Function to cleanup containers
cleanup_containers() {
    echo "🧹 Checking for containers to cleanup..."
    
    # Get containers in Created or Exited state
    CONTAINERS_TO_REMOVE=$(/usr/local/bin/k3s crictl ps -aq --state Created --state Exited 2>/dev/null || true)
    
    if [ -n "$CONTAINERS_TO_REMOVE" ]; then
        echo "Found containers to remove:"
        /usr/local/bin/k3s crictl ps -a --state Created --state Exited 2>/dev/null || true
        echo
        
        echo "🗑️  Removing stopped containers..."
        echo "$CONTAINERS_TO_REMOVE" | xargs -r /usr/local/bin/k3s crictl rm
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
    if /usr/local/bin/k3s crictl rmi --prune 2>/dev/null; then
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

echo "📁 Creating log directory..."
mkdir -p /var/log
touch /var/log/k3s-cleanup.log

# Configure logrotate
echo "🔄 Configuring logrotate..."
LOGROTATE_CONFIG="/etc/logrotate.d/k3s-cleanup"

cat > "$LOGROTATE_CONFIG" <<EOF
/var/log/k3s-cleanup.log {
    daily
    rotate $LOG_KEEP_DAYS
    compress
    delaycompress
    missingok
    notifempty
    create 0644 root root
}
EOF

echo "✅ Logrotate configured: keeping logs for $LOG_KEEP_DAYS days"

# Add crontab entry
echo "⏰ Configuring crontab entry..."
CRON_ENTRY="$CRON_SCHEDULE /usr/local/bin/k3s-cleanup.sh >> /var/log/k3s-cleanup.log 2>&1"

# Remove existing k3s-cleanup crontab entries if they exist
if crontab -l 2>/dev/null | grep -q "k3s-cleanup"; then
    echo "🗑️  Removing existing k3s-cleanup crontab entries..."
    crontab -l 2>/dev/null | grep -v "k3s-cleanup" | grep -v "# k3s cleanup" | crontab - || true
    echo "✅ Existing entries removed"
fi

# Add the new cron job
echo "➕ Adding new crontab entry..."
(crontab -l 2>/dev/null; echo "# k3s cleanup"; echo "$CRON_ENTRY") | crontab -
echo "✅ Crontab entry added successfully"

# Verify installation
echo
echo "🔍 Verifying installation..."
echo "Script location: /usr/local/bin/k3s-cleanup.sh"
ls -la /usr/local/bin/k3s-cleanup.sh

echo
echo "📅 Current crontab entries:"
crontab -l | grep -A1 -B1 "k3s-cleanup" || echo "No k3s-cleanup entries found"

echo
echo "🔄 Logrotate configuration:"
cat /etc/logrotate.d/k3s-cleanup

echo
echo "✅ K3s cleanup installation completed successfully!"
echo "Schedule: $CRON_SCHEDULE"
echo "Log retention: $LOG_KEEP_DAYS days"
echo "Log file: /var/log/k3s-cleanup.log"
echo
echo "To test the script manually, run:"
echo "sudo /usr/local/bin/k3s-cleanup.sh"
echo
echo "To change the configuration, run this script again:"
echo "sudo $0 -s '0 */6 * * *' -lk 16  # Example: every 6 hours, keep logs for 16 days"
