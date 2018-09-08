#!/bin/sh
cd $(dirname $0)

if [ "${ELASTICSEARCH_URL}" = "" ]
then
    echo 'Please set the Environment variable "ELASTICSEARCH_URL".'
    exit 1
fi

REPORT_ROOT_PATH='report'
REPORT_FILE_SUFFIX='psi.report.json'
BULK_DATA_PATH="${REPORT_ROOT_PATH}/bulk.jsonl"

createBulk () {
    index_name='psi'
    type_name='psi'
    rm -f ${BULK_DATA_PATH}
    raw_data_path_array=`find ${REPORT_ROOT_PATH} -name "*${REPORT_FILE_SUFFIX}"`
    for raw_data_path in $raw_data_path_array; do
        echo "${raw_data_path}"
        target_url_value=`dirname ${raw_data_path} | sed "s#${REPORT_ROOT_PATH}\/##g"`
        datetime_value=`basename ${raw_data_path} | sed "s#_${REPORT_FILE_SUFFIX}##g"`
        date_value=${datetime_value:0:8}
        post_data=`cat ${raw_data_path} | sed 's#\\\"##g' | sed 's#\\\##g' | sed 's#\`##g' | tr -d '\n' | sed "s#^{#{ \"target_url\": \"${target_url_value}\", \"date\": \"${date_value}\", \"datetime\": \"${datetime_value}\",#"`
        echo "{ \"index\" : { \"_index\" : \"${index_name}\", \"_type\" : \"${type_name}\" } }" >> ${BULK_DATA_PATH}
        echo "${post_data}" >> ${BULK_DATA_PATH}
    done
}

createBulk
cd `dirname ${BULK_DATA_PATH}`
curl -s -H "Content-Type: application/x-ndjson" -XPOST "${ELASTICSEARCH_URL}/_bulk?pretty" --data-binary '@'`basename ${BULK_DATA_PATH}`
