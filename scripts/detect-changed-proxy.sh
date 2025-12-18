#!/bin/bash
set -e

echo "🔍 Detecting changed proxies..."

# Determine the base commit (fixes HEAD~1 issue)
if ! git rev-parse HEAD~1 >/dev/null 2>&1; then
  echo "⚠️ No HEAD~1 — using initial commit"
  BASE=$(git rev-list --max-parents=0 HEAD)
else
  BASE=HEAD~1
fi

echo "Using base reference: $BASE"

# List changed files
echo "Changed files:"
git diff --name-only $BASE HEAD

# Extract ALL changed proxy folders
CHANGED_PROXIES=$(git diff --name-only $BASE HEAD \
  | grep "^api-proxies/" \
  | cut -d'/' -f2 \
  | sort \
  | uniq)

if [ -z "$CHANGED_PROXIES" ]; then
  echo "❌ No proxy changes detected."
  exit 1
fi

echo "✅ Changed proxies detected:"
echo "$CHANGED_PROXIES"

# Export variable for Azure Pipeline
echo "##vso[task.setvariable variable=CHANGED_PROXIES]$CHANGED_PROXIES"
