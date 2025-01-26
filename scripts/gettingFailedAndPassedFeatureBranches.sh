#!/bin/bash
#This code makes 
#Fetch AccelQ Test Results:1.Retrieves the test results from the AccelQ API using the provided API token, execution ID, and user ID.2.Saves the test results in a local file called accelq-results.json.
#Identify Failed Branches:1.Extracts branches with failed tests from the JSON response using jq.2.Outputs a list of failed branches. If no branches failed, it notifies the user.
#Identify Passed Branches:1.Extracts branches with passed tests from the JSON response using jq.2.Outputs a list of passed branches. If no branches passed, it notifies the user.
#Output Results:1.If there are failed branches, they are listed under "Failed branches."2.If there are passed branches, they are listed under "Passed branches."
#Clean Up:1.Deletes the accelq-results.json file to clean up temporary data.
#Completion Notification:Displays a message indicating that the process has completed.
#

# AccelQ API credentials
API_TOKEN="_vEXPgyaqAxtXL7wbvzvooY49cnsIYYHrWQMJH-ZcEM"
EXECUTION_ID="452922"
USER_ID="koray.ayakin@pargesoft.com"

# Step 1: Fetch AccelQ Test Results
echo "Fetching AccelQ test results..."
curl -X GET "https://poc.accelq.io/awb/api/1.0/poc25/runs/${EXECUTION_ID}" \
  -H "api_key: ${API_TOKEN}" \
  -H "user_id: ${USER_ID}" \
  -H "Content-Type: application/json" > accelq-results.json
echo "AccelQ test results saved to accelq-results.json"

# Step 2: Identify Failed and Passed Branches
echo "Identifying failed and passed branches..."

# Extract failed branches
FAILED_BRANCHES=$(jq -r '.summary.testCaseSummaryList[] | select(.status == "fail") | .metadata.tags[]' accelq-results.json | sort | uniq)

# Extract passed branches
PASSED_BRANCHES=$(jq -r '.summary.testCaseSummaryList[] | select(.status == "pass") | .metadata.tags[]' accelq-results.json | sort | uniq)

# Check if there are any failed branches
if [[ -z "$FAILED_BRANCHES" ]]; then
  echo "No failed branches found."
else
  echo "Failed branches:"
  echo "$FAILED_BRANCHES"
fi

# Check if there are any passed branches
if [[ -z "$PASSED_BRANCHES" ]]; then
  echo "No passed branches found."
else
  echo "Passed branches:"
  echo "$PASSED_BRANCHES"
fi

# Cleanup
rm -f accelq-results.json

echo "Completed processing branches."