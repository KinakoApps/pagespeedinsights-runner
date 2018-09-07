#!/bin/sh
cd $(dirname $0)

if [ "${PSI_API_KEY}" = "" ]
then
    echo "Please set the Environment variable PSI_API_KEY."
    exit 1
fi

TARGET_CSV_PATH='target.csv'
REPORT_ROOT_PATH="report"
PSI_API_URL=https://www.googleapis.com/pagespeedonline/v4/runPagespeed

source ./functions.sh

target_urls=$(getTargetUrls "${TARGET_CSV_PATH}")
echo 'Targets: ['"${target_urls}"']'
target_url_array=(`echo ${target_urls} | tr -s ',' ' '`)
for target_url in ${target_url_array[@]}; do
    echo ${target_url}
    analyzePSI "${target_url}" `getDateTimeText`
done
