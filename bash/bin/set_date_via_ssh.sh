#!/usr/bin/env bash

set -euo pipefail

HOST="${1:-}"

if [[ -z "$HOST" ]]; then
  echo "Error: missing SSH host argument." >&2
  echo "Usage: $0 <host>" >&2
  exit 1
fi

UTC_TIME="$(date -u +"%Y-%m-%d %H:%M:%S") UTC"

echo "Setting system time on '$HOST' to UTC: $UTC_TIME"

ssh -t "$HOST" "sudo date -s '$UTC_TIME'"


