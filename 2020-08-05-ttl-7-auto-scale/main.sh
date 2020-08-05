#!/bin/bash

set -o xtrace
pre="autoscale"


# 实验目的：
# 这里是测试，按照 weipin的1~16个ingress controller的要求在测一个性能表

for((pod=50;pod>0;pod-=5)); do
    # remove logs files on disk
    # sync cache on the os memory

    scu test-default-4 ${pod}
    date
    
    dir="${pre}.ingress.svc.${pod}"
    sleep 30
    ./2020-06-28-main.just.ingress.svc.sh ${dir}
    sleep 30

    for ((j=0;j<100;j++)); do
       file=${j}
       ku top pod > ${dir}/${file}
       ku top node > ${dir}/${file}.node
       ks top pod > ${dir}/${file}.sys.pod
       sleep 6
    done

    sleep 400
    wait
done

set +o xtrace
