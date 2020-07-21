#!/bin/bash

set -e


for n in `ls | grep ^2core|  grep -v 16pod`; do
    if [[ -d ${n} ]]; then
        cd ${n}
        ret=`cat *.log | grep Request | awk '{print $2}' | paste -s -d+ | bc`
        echo "${n}   ${ret}"
        cd ..
    fi
done

