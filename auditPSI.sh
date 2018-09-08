#!/bin/sh
cd $(dirname $0)

if [ "${PSI_API_KEY}" = "" ]
then
    echo 'Please set the Environment variable "PSI_API_KEY".'
    exit 1
fi

TARGET_CSV_PATH='target.csv'
REPORT_ROOT_PATH='report'
PSI_API_URL=https://www.googleapis.com/pagespeedonline/v4/runPagespeed

auditPSI () {
    target_url=$1
    start_time=$2
    REPORT_RELATIVE_PATH=`echo ${target_url} | sed -e "s#https://##g" -e "s#http://##g"`
    REPORT_OUT_DIR_PATH="${REPORT_ROOT_PATH}/${REPORT_RELATIVE_PATH}"
    REPORT_OUT_FILE_PATH="${REPORT_OUT_DIR_PATH}/${start_time}_psi.report.json"
    # Create report directory.
    mkdir -p ${REPORT_OUT_DIR_PATH}
    # Run PageSpeedInsights.
    curl -s "${PSI_API_URL}?strategy=mobile&key=${PSI_API_KEY}&url=${target_url}" -o ${REPORT_OUT_FILE_PATH}
}

for line in `cat ${TARGET_CSV_PATH} | grep -v ^#`
do
    target_url=`echo ${line} | cut -d ',' -f 1`
    target_description=`echo ${line} | cut -d ',' -f 2`
    echo ${target_description}' ('${target_url}')'
    auditPSI "${target_url}" `date +%Y%m%dT%H%M%SZ`
done
