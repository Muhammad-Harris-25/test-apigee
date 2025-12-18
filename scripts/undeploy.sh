#!/bin/bash

ORG=$1
access_token=$2
ProxyName=$3
my_stable_revision=$4
ENV=$5

echo "ENV: '$ENV'"
echo "access_token: $access_token"

# Get stable_revision_number using access_token
current_revision_info=$(curl -H "Authorization: Bearer $access_token" "https://apigee.googleapis.com/v1/organizations/$ORG/environments/$ENV/apis/$ProxyName/deployments")

# Check if the curl command was successful
if [ $? -eq 0 ]; then
    # Extract the revision number using jq, handling the case where .deployments is null or empty
    rev_num=$(echo "$current_revision_info" | jq -r ".deployments[0]?.revision // null")

    echo "Current Revision: '$rev_num'"
else
    # Handle the case where the curl command failed
    echo "Error: Failed to retrieve API deployments."
fi


echo "Current Revision: '$rev_num'"
echo "Current API Name: '$ProxyName'"
echo "Current ORG Name: '$ORG'"
echo "Current ENV Name: '$ENV'"
echo "Stable Revision: '$my_stable_revision'"


if [[ "${my_stable_revision}" -eq null ]];
then
	echo "WARNING: Test failed, undeploying and deleting Current Revision: '$rev_num'"

	curl -X DELETE --header "Authorization: Bearer $access_token" "https://apigee.googleapis.com/v1/organizations/$ORG/environments/$ENV/apis/$ProxyName/revisions/$rev_num/deployments"

	curl -X DELETE --header "Authorization: Bearer $access_token" "https://apigee.googleapis.com/v1/organizations/$ORG/apis/$ProxyName/revisions/$rev_num"
	
	curl -X DELETE --header "Authorization: Bearer $access_token" "https://apigee.googleapis.com/v1/organizations/$ORG/apis/$ProxyName"
else
echo "WARNING: Test failed, reverting from Current Revision: '$rev_num' to Stable Revision: '$my_stable_revision' --- undeploying and deleting revision $rev_num"

curl -X DELETE --header "Authorization: Bearer $access_token" "https://apigee.googleapis.com/v1/organizations/$ORG/environments/$ENV/apis/$ProxyName/revisions/$rev_num/deployments"

curl -X DELETE --header "Authorization: Bearer $access_token" "https://apigee.googleapis.com/v1/organizations/$ORG/apis/$ProxyName/revisions/$rev_num"

echo ""
echo "Successfully undeployed current revision : '$rev_num'"

curl -X POST --header "Content-Type: application/x-www-form-urlencoded" --header "Authorization: Bearer $access_token" "https://apigee.googleapis.com/v1/organizations/$ORG/environments/$ENV/apis/$ProxyName/revisions/$my_stable_revision/deployments"

echo ""
echo "Successfully deployed stable revision : '$my_stable_revision'"
fi
