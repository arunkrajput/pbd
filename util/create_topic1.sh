#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <config_file> <csv_file>"
  exit 1
fi

CONFIG_FILE="$1"
CSV_FILE="$2"

# Validate if files exist
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: Config file not found: $CONFIG_FILE"
  exit 1
fi

if [ ! -f "$CSV_FILE" ]; then
  echo "Error: CSV file not found: $CSV_FILE"
  exit 1
fi

# Read CSV file and create topics
while IFS=, read -r topic partitions replication_factor; do
  echo "Creating topic: $topic"
  kafka_2.13-2.8.0/bin/kafka-topics.sh --create \
                  --topic "$topic" \
                  --partitions "$partitions" \
                  --replication-factor "$replication_factor" \
                  --command-config "$CONFIG_FILE"
done < "$CSV_FILE"
