#!/usr/bin/env bash

set -e

mkdir -p ./data
docker-compose up --build --abort-on-container-exit

