#!/bin/bash

set -e


for n in `ls | grep ^2020-06| grep -v 16pod`; do
    if [[ -d ${n} ]]; then
        cd ${n}
        ret=`cat *.log | grep timeout | awk '{print $10}' | paste -s -d+ | bc`
        if [[ ${#ret} -eq 0 ]]; then
            ret="0"
        fi
        echo "${n}   ${ret}"
        cd ..
    fi
done

