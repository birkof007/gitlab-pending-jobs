#!/bin/bash

#####################################################################################################
# Get number of pending jobs in Gitlab with GraphQL for Icinga. It return number almost in real time.
# Set threshold as you need.
#####################################################################################################

TOKEN="xxxxxxxxxxxxx"
GITLAB_URL="https://your-gitlab-url.com"

pending=$(curl -s --header "PRIVATE-TOKEN: $TOKEN" "$GITLAB_URL/api/graphql" -d "query={jobs{nodes{active id status}}}" | jq '.data.jobs.nodes[] | select(.status == "PENDING") | .id' | wc -l )

if [[ $pending = "0" ]]; then
  echo "OK - no pending jobs"
  exit 0
else
  if [[ $pending -le "10" ]]; then
    echo "WARNING - $pending pending jobs. No need to panic :)"
    exit 0
  else
    echo "CRITICAL - $pending pending jobs"
    exit 2
  fi
fi
