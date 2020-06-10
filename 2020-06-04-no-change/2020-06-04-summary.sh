#!/bin/bash

set -e

echo "All POD is 1CPU 1GB Memroy"

echo "Settings: 64 ingress POD, 80 app POD."

for n in `ls | grep ^2020-06-03 | grep -v 16pod`; do
    if [[ -d ${n} ]]; then
        cd ${n}
        ret=`cat *.log | grep Request | awk '{print $2}' | paste -s -d+ | bc`
        echo "${n}   ${ret}"
        cd ..
    fi
done

