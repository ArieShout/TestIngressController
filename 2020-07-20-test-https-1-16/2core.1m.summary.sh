#!/bin/bash

set -e

for n in `ls | grep ^1m.2core.https.ingress.svc |  grep -v 16pod`; do
    if [[ -d ${n} ]]; then
        cd ${n}
        ret=`cat *.log | grep MB | grep Transfer | tr "MB" " " | awk '{print $2}' | paste -s -d+ | bc`
        echo "${n}   ${ret}"
        cd ..
    fi
done

