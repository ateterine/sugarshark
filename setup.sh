#!/bin/bash

sudo apt-get update
sudo apt-get install awscli

aws configure

mkdir -p ~/logs
chmod 755 ~/logs
touch ~/logs/s3_sync.log
chmod 644 ~/logs/s3_sync.log

# Ask for S3 path modification
echo "Enter the subpath for S3 bucket (leave empty to keep default):"
read -r subpath

# Set S3 bucket based on user input
if [ -z "$subpath" ]; then
    S3_BUCKET="s3://fpp-accordios/videos/All"
else
    S3_BUCKET="s3://fpp-accordios/videos/$subpath/"
fi

echo "Using S3 bucket path: $S3_BUCKET"

# Define the file name
SCRIPT_FILE="s3_poll_sync.sh"

# Write the script content
cat <<'EOF' >"$SCRIPT_FILE"
#!/bin/bash

# Define Variables
S3_BUCKET="$S3_BUCKET"
DEST_FOLDER="/home/fpp/media/videos/"
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

crontab -e
