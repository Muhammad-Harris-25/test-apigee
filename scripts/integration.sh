#!/bin/bash
set -e

# Debugging: list files in the current directory
ls -ltr

# Capture arguments
ORG=$1
NEWMAN_TARGET_COLLECTION=$2

echo "ORG: $ORG"
echo "NEWMAN_TARGET_COLLECTION: $NEWMAN_TARGET_COLLECTION"

# Azure DevOps sets this automatically
WORKDIR="$BUILD_SOURCESDIRECTORY"

# Check connectivity to the host before running 
echo $WORKDIR
ls -ltr
API_HOST=$(grep -oE "https?://[^/]+" "$WORKDIR/tests/integration/$NEWMAN_TARGET_COLLECTION" | head -1)
if [ -n "$API_HOST" ]; then
  echo "🔎 Testing connectivity to API host: $API_HOST"
  curl -vk "$API_HOST" || echo "⚠️ Warning: Could not reach $API_HOST"
else
  echo "⚠️ No API host found in collection, skipping connectivity test"
fi

# Install Newman globally (if not already installed)
if ! command -v newman &> /dev/null; then
  echo "Installing Newman..."
  npm install -g newman
fi

# Run Newman tests
newman run "$WORKDIR/tests/integration/$NEWMAN_TARGET_COLLECTION" \
  --reporters cli,junit \
  --reporter-junit-export "$WORKDIR/junitReport.xml" \
  --env-var client_id=$id \
  --env-var client_secret=$secret \
  --insecure
