#!/bin/bash

curl -L -X POST 'http://localhost:8191/v1' \
-H 'Content-Type: application/json' \
--data-raw '{
  "cmd": "request.get",
  "url": "https://manualzz.com/doc/2014268/a/",
  "maxTimeout": 60000
}' -o HTML
