#!/bin/bash

function setupTable {
    if [[ -z "$ASTRA_DB_USERNAME" ]]; then
      echo "What is your Astra DB username? 🚀"
      read -r ASTRA_DB_USERNAME
      export ASTRA_DB_USERNAME="${ASTRA_DB_USERNAME}"
      gp env ASTRA_DB_USERNAME="${ASTRA_DB_USERNAME}" &> /dev/null
    fi

    if [[ -z "$ASTRA_DB_PASSWORD" ]]; then
      echo "What is your Astra DB password? 🔒"
      read -s ASTRA_DB_PASSWORD
      export ASTRA_DB_PASSWORD="${ASTRA_DB_PASSWORD}"
      gp env ASTRA_DB_PASSWORD="${ASTRA_DB_PASSWORD}" &> /dev/null
    fi

    if [[ -z "$ASTRA_DB_KEYSPACE" ]]; then
      echo "What is your Astra keyspace name? 🔑"
      read -r ASTRA_DB_KEYSPACE
      export ASTRA_DB_KEYSPACE="${ASTRA_DB_KEYSPACE}"
      gp env ASTRA_DB_KEYSPACE="${ASTRA_DB_KEYSPACE}" &> /dev/null
    fi

    if [[ -z "$ASTRA_DB_ID" ]]; then
      echo "What is your Astra database id? Example: 4e62bc79-0e12-4667-bd7d-2191ece2a32c ☁️"
      read -r ASTRA_DB_ID
      export ASTRA_DB_ID="${ASTRA_DB_ID}"
      gp env ASTRA_DB_ID="${ASTRA_DB_ID}" &> /dev/null
    fi

    if [[ -z "$ASTRA_DB_REGION" ]]; then
      echo "What is your Astra database region? Example: us-east1 🌍"
      read -r ASTRA_DB_REGION
      export ASTRA_DB_REGION="${ASTRA_DB_REGION}"
      gp env ASTRA_DB_REGION="${ASTRA_DB_REGION}" &> /dev/null
    fi

    # Get Astra auth token
    echo "Getting your Astra auth token..."
    AUTH_TOKEN=$(curl --request POST \
      --url "https://${ASTRA_DB_ID}-${ASTRA_DB_REGION}.apps.astra.datastax.com/api/rest/v1/auth" \
      --header 'content-type: application/json' \
      --data '{"username":"'"${ASTRA_DB_USERNAME}"'","password":"'"${ASTRA_DB_PASSWORD}"'"}' | jq -r '.authToken')

    # Create todos table
    echo "Creating Astra tables..."
    TABLE_CREATION=$(curl --request POST \
      --url "https://${ASTRA_DB_ID}-${ASTRA_DB_REGION}.apps.astra.datastax.com/api/rest/v1/keyspaces/${ASTRA_DB_KEYSPACE}/tables" \
      --header 'content-type: application/json' \
      --header "x-cassandra-token: ${AUTH_TOKEN}" \
      --data '{"ifNotExists":true,"columnDefinitions":[{"static":false,"name":"list_id","typeDefinition":"text"},{"static":false,"name":"id","typeDefinition":"timeuuid"},{"static":false,"name":"title","typeDefinition":"text"},{"static":false,"name":"completed","typeDefinition":"boolean"}],"primaryKey":{"partitionKey":["list_id","id"]},"tableOptions":{"defaultTimeToLive":0,"clusteringExpression":[{"column":"id","order":"DESC"}]},"name":"todos"}')
}

setupTable
echo $TABLE_CREATION

while [ ! "$TABLE_CREATION" = '{"success":true}' ]
do
  echo "Your Database details were invalid. Trying again:"
  unset ASTRA_DB_ID
  unset ASTRA_DB_REGION
  unset ASTRA_DB_KEYSPACE
  unset ASTRA_DB_PASSWORD
  unset ASTRA_DB_USERNAME
  setupTable
done
