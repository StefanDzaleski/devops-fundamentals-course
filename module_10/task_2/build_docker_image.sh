#!/bin/bash

docker build -t calorie-calculator-backend-v8 .
docker tag calorie-calculator-backend-v8 stefandjaleski/calorie-calculator-backend:v8
docker push stefandjaleski/calorie-calculator-backend:v8