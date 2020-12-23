#!/bin/bash

url='http://localhost:9093/api/v1/alerts'
name="my_cool_alert_$RANDOM"
echo "Firing up alert $name"
startsAt=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
echo $startsAt
curl -XPOST $url -d '[{"status": "firing","labels": {"alertname": "'$name'","service": "curl","severity": "warning","instance": "0"},"annotations": {"summary": "This is a summary","description": "This is a description."},"generatorURL": "http://prometheus.int.example.net/<generating_expression>","startsAt": "'$startsAt'"}]'
echo ""

echo "press enter to resolve alert"
read
endsAt=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
echo $endsAt

echo "sending resolve"
curl -XPOST $url -d '[{"status": "resolved","labels": {"alertname": "'$name'","service": "curl","severity": "warning","instance": "0"},"annotations": {"summary": "This is a summary","description": "This is a description."},"generatorURL": "http://prometheus.int.example.net/<generating_expression>","startsAt": "'$startsAt'","endsAt": "'$endsAt'"}]'
echo ""
