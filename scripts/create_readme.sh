#!/bin/bash

ARCHIVE_NAME="$1"
REPO_ID="$2"
TOTAL_SIZE_MB="$3"
FILE_COUNT="$4"
PART_COUNT="$5"
PART_SIZE="$6"
PASSWORD="$7"
REPO_NAME=$(basename "$REPO_ID")

README_FILE="README_${ARCHIVE_NAME}.md"

cat > "$README_FILE" << EOF
# ${REPO_NAME} - HuggingFace Repository Archive

## Download Information
- **Original Repository**: ${REPO_ID}
- **Archive Name**: \`${ARCHIVE_NAME}.zip\`
- **Total Size**: ${TOTAL_SIZE_MB} MB
- **Files**: ${FILE_COUNT} files
- **Parts**: ${PART_COUNT} parts (${PART_SIZE}MB each)
- **Password Protected**: **YES**

## Password
\`\`\`
${PASSWORD}
\`\`\`

## How to Extract

### Windows (7-Zip/WinRAR):
1. Download **all** parts (\`.zip\`, \`.z01\`, \`.z02\`, etc.)
2. Put them in the **same folder**
3. Right-click on \`${ARCHIVE_NAME}.zip\`
4. Select "Extract Here" or "Extract to folder"
5. Enter password: \`${PASSWORD}\`

### Linux/Mac:
\`\`\`bash
# Download all parts to same directory, then:
unzip ${ARCHIVE_NAME}.zip

# Or extract with password:
unzip -P "${PASSWORD}" ${ARCHIVE_NAME}.zip
\`\`\`

### Python:
\`\`\`python
import zipfile
with zipfile.ZipFile('${ARCHIVE_NAME}.zip', 'r') as zip_ref:
    zip_ref.extractall('.', pwd=b'${PASSWORD}')
\`\`\`

## File List
EOF

# Add file list if directory exists
if [ -d "downloaded_repo" ]; then
  cd downloaded_repo && find . -type f | head -50 | sed 's/^/- /' >> "../$README_FILE" && cd ..
fi

# Add footer
cat >> "$README_FILE" << EOF

---
*Archived on: $(date '+%Y-%m-%d %H:%M:%S UTC')*
*Original source: https://huggingface.co/${REPO_ID}*
EOF

echo "README created: $README_FILE"
