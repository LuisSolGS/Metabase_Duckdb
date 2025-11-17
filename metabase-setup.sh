#!/bin/bash
# Define the API endpoint
echo 'Metabase is up. Running setup...';

curl -X POST http://metabase:3000/api/setup -H 'Content-Type: application/json' \
-d "{
  \"token\":\"$MB_TOKEN\",
  \"prefs\":{\"site_name\":\"Metabase\"},\"user\":{\"email\":\"$MB_USER_EMAIL\",\"password\":\"$MB_USER_PASSWORD\",\"first_name\":\"$MB_FIRST_NAME\",\"last_name\":\"$MB_LAST_NAME\"}
  }";

echo 'Setup complete.';

echo 'Requesting session token...';

SESSION_ID=$(curl http://metabase:3000/api/session/ \
  --request POST \
  --header 'Content-Type: application/json' \
  --data "{
  \"password\": \"$MB_USER_PASSWORD\",
  \"username\": \"$MB_USER_EMAIL\"
}")

echo "Session token acquired: $SESSION_ID";

echo 'Adding database connection to Metabase...';

ID=$(echo "$SESSION_ID" | sed -n 's/.*"id":"\([^"]*\)".*/\1/p')
echo "$ID"

STATUS=$(curl http://metabase:3000/api/database/ \
  --request POST \
  --header 'Content-Type: application/json' \
  --header "X-Metabase-Session: $ID" \
  --data "{
    \"engine\": \"postgres\",
    \"name\": \"$MB_DB_DBNAME\",
    \"details\": {
      \"host\": \"db\",
      \"port\": 5432,
      \"dbname\": \"$MB_DB_DBNAME\",
      \"user\": \"$MB_DB_USER\",
      \"password\": \"$MB_DB_PASS\",
      \"ssl\": false
    },
    \"is_full_sync\": true,
    \"schedules\": {
      \"cache_field_values\": {
        \"schedule_day\": \"sun\",
        \"schedule_frame\": \"first\",
        \"schedule_hour\": 0,
        \"schedule_minute\": 0,
        \"schedule_type\": \"hourly\"
      },
      \"metadata_sync\": {
        \"schedule_day\": \"sun\",
        \"schedule_frame\": \"first\",
        \"schedule_hour\": 0,
        \"schedule_minute\": 0,
        \"schedule_type\": \"hourly\"
      }
    }
  }");

echo "$STATUS"

echo 'Setup done.';
