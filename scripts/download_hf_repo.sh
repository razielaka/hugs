#!/bin/bash

REPO_ID="$1"

echo "Downloading: $REPO_ID"

# Create download directory
mkdir -p downloaded_repo

# Try using hf CLI first (new method)
if command -v hf &> /dev/null; then
  echo "Using hf CLI to download..."
  hf download "$REPO_ID" --local-dir ./downloaded_repo
    
  if [ $? -eq 0 ] && [ "$(ls -A downloaded_repo)" ]; then
    echo "✅ Download successful with hf CLI"
    # Remove .hf directory if it exists
    rm -rf downloaded_repo/.hf 2>/dev/null || true
    exit 0
  fi
fi

# Fallback to git clone with LFS
echo "Falling back to git clone with LFS..."
rm -rf downloaded_repo
git clone "https://huggingface.co/${REPO_ID}" downloaded_repo

if [ $? -ne 0 ]; then
  echo "❌ Git clone failed"
  exit 1
fi

cd downloaded_repo
git lfs pull

if [ $? -ne 0 ]; then
  echo "⚠️ LFS pull had issues, but continuing..."
fi

cd ..

# Remove .git directory
rm -rf downloaded_repo/.git
rm -f downloaded_repo/.gitattributes
rm -f downloaded_repo/.gitignore

echo "✅ Download complete using git clone"
