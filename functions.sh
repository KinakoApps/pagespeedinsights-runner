#!/bin/sh

# Functions.
getDateTimeText () {
    echo `date +%Y-%m-%d-%H-%M-%S`
}

getTargetUrls () {
    target_urls=''
    target_csv=$1
    for line in `cat ${target_csv} | grep -v ^#`
    do
        url=`echo ${line} | cut -d ',' -f 1`
        target_urls+=${url}','
    done
    target_urls=$(echo ${target_urls} | sed -e "s/,\$//")
    echo ${target_urls}
}

showVersions () {
    docker run --rm \
    ${DOCKER_IMAGE_NAME} \
    bash -c "echo 'Chrome version: ' && google-chrome --version && echo 'Lighthouse verson: ' && lighthouse --version"
}

analyzePSI () {
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
