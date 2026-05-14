#!/bin/bash

REPO_ID="$1"

echo "Downloading: $REPO_ID"

# Create download directory
mkdir -p downloaded_repo

# Use huggingface-cli to download all files (handles XetHub properly)
huggingface-cli download \
  "$REPO_ID" \
  --local-dir ./downloaded_repo \
  --local-dir-use-symlinks False \
  --resume-download \
  --quiet

echo "Download complete. Contents:"
ls -la downloaded_repo/
echo ""
echo "File sizes:"
du -sh downloaded_repo/* 2>/dev/null || echo "No files found"

# Remove any Git-related files and directories
rm -rf downloaded_repo/.git 2>/dev/null || true
rm -f downloaded_repo/.gitattributes 2>/dev/null || true
rm -f downloaded_repo/.gitignore 2>/dev/null || true

echo "Cleaned directory (removed .git files):"
ls -la downloaded_repo/
