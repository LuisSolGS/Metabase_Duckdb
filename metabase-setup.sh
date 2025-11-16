#!/bin/bash
# Define the API endpoint
echo 'Metabase is up. Running setup...';

echo "$MB_USER_EMAIL";

curl -X POST http://metabase:3000/api/setup -H 'Content-Type: application/json' \
-d '{
  "token":"mysecrettoken123",
  "prefs":{"site_name":"My Metabase"},"user":{"email":"admin@example.com","password":"StrongPass123!","first_name":"Admin","last_name":"User"}
  }';

echo 'Setup complete.';

echo 'Requesting session token...';

SESSION_ID=$(curl http://metabase:3000/api/session/ \
  --request POST \
  --header 'Content-Type: application/json' \
  --data '{
  "password": "StrongPass123!",
  "username": "admin@example.com"
}')

echo "Session token acquired: $SESSION_ID";

echo 'Adding database connection to Metabase...';

name=$(echo "$SESSION_ID" | sed -n 's/.*"id":"\([^"]*\)".*/\1/p')
echo "$name"

STATUS=$(curl http://metabase:3000/api/database/ \
  --request POST \
  --header 'Content-Type: application/json' \
  --header "X-Metabase-Session: $name" \
  --data '{
    "engine": "postgres",
      "name": "My New Database",
      "details": {
        "host": "db",
        "port": 5432,
        "dbname": "metabase",
        "user": "metabase",
        "password": "metabase",
        "ssl": false
      },
      "is_full_sync": true,
      "schedules": {
        "cache_field_values": {
        "schedule_day": "sun",
        "schedule_frame": "first",
        "schedule_hour": 0,
        "schedule_minute": 0,
        "schedule_type": "hourly"
      },
      "metadata_sync": {
        "schedule_day": "sun",
        "schedule_frame": "first",
        "schedule_hour": 0,
        "schedule_minute": 0,
        "schedule_type": "hourly"
      }
      }
}');

echo "$STATUS"

echo 'Setup done.';
