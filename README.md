# PageSpeedInsights Runner

Multi Target Runner for [Google PageSpeed Insights](https://developers.google.com/speed/pagespeed/insights/).

## Requirement
* bash

## Usage

### Create Target CSV
```
cp target.example.csv target.csv
vi taget.csv
```

### Run PageSpeedInsights
```
export PSI_API_KEY=${Your_PageSpeedInsights_API_KEY}
sh auditPSI.sh
```

### POST to Slack (Optional)
Note: This shell requires [jq](https://stedolan.github.io/jq/).
```
export SLACK_INCOMING_WEBHOOK_URL=${Your_Slack_Incoming_Webhook_URL}
export SLACK_CHANNEL_NAME='#debug'
sh postPSI2Slack.sh
```

### POST to Elasticsearch (Optional)
```
export ELASTICSEARCH_URL='http://localhost:9200'
sh postPSI2ES.sh
```
