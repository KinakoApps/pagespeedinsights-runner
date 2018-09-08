# PageSpeedInsights Runner

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
export PSI_API_KEY=${YOUR_PageSpeedInsights_API_KEY}
sh auditPSI.sh
```

### POST to Elasticsearch (Optional)
```
export ELASTICSEARCH_URL='http://localhost:9200'
sh postPSI.sh
```
