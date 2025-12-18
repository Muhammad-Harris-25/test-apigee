#!/bin/bash
set -e

ORG=$1
ProxyName=$2
ENV=$3
KEY_FILE=$4

echo "ORG: $ORG"
echo "ProxyName: $ProxyName"
echo "ENV: $ENV"
echo "Using service account key: $KEY_FILE"

if [ ! -f "$KEY_FILE" ]; then
  echo "❌ Service account key file '$KEY_FILE' not found."
  exit 1
fi

echo "🔑 Authenticating with service account..."
gcloud auth activate-service-account --key-file="$KEY_FILE"


# Fetch access token  
access_token=$(gcloud auth print-access-token)

if [ -z "$access_token" ]; then
  echo "❌ Failed to obtain access token."
  exit 1
fi

echo "✅ Access Token acquired."

revision_info=$(curl -s -H "Authorization: Bearer $access_token" \
  "https://apigee.googleapis.com/v1/organizations/$ORG/environments/$ENV/apis/$ProxyName/deployments")

stable_revision_number=$(echo "$revision_info" | jq -r ".deployments[0]?.revision // null")

echo "##vso[task.setvariable variable=access_token;isOutput=true]$access_token"
echo "##vso[task.setvariable variable=stable_revision_number;isOutput=true]$stable_revision_number"
