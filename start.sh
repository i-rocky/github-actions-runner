#!/usr/bin/env bash

set -e

if [ -z "$URL" ]; then
    echo "URL is required"
    exit 1
fi

if [ -z "$TOKEN" ]; then
    echo "TOKEN is required"
    exit 1
fi

cd /home/docker/actions-runner || exit 1

./config.sh --url "$URL" --token "$TOKEN"

cleanup() {
  echo "Cleaning up..."
    ./config.sh remove --unattended --token "$TOKEN"
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
