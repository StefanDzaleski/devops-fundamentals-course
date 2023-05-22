#!/usr/bin/env bash

../subtask_1/quality-check.sh

./build-client.sh

./ssh_deploy-apps.sh
