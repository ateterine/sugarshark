#!/bin/bash

apt-get update
apt-get awslcli

aws configure

mkdir -p ~/logs
chmod 755 ~/logs
touch ~/logs/s3_sync.log
chmod 644 ~/logs/s3_sync.log

# Define the file name
SCRIPT_FILE="s3_poll_sync.sh"

# Write the script content
cat <<'EOF' >"$SCRIPT_FILE"
#!/bin/bash

# Define Variables
S3_BUCKET="s3://fpp-accordios/videos"
DEST_FOLDER="/your/destination/folder"
LOG_FILE="$HOME/logs/s3_sync.log"

# Ensure the destination folder exists
mkdir -p "$DEST_FOLDER"

# Function to sync files
sync_s3() {
    echo "$(date) - Checking for updates..." | tee -a "$LOG_FILE"
    aws s3 sync "$S3_BUCKET" "$DEST_FOLDER"
    echo "$(date) - Sync completed." | tee -a "$LOG_FILE"
}

# Run the sync every 5 minutes (using cron)
while true; do
    sync_s3
    sleep 300  # Poll every 5 minutes
done
EOF

# Make the script executable
chmod +x "$SCRIPT_FILE"

echo "Script $SCRIPT_FILE has been created and made executable."
