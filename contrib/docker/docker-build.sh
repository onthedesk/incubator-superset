#!/usr/bin/env bash

set -ex

docker build -t onthedesk/superset -f Dockerfile .
