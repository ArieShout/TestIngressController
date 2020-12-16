#!/bin/bash

set -o xtrace
pre="cons-32-sys"


# 实验目的：
# 在缺省的keep_alive_connections = 32的时候，通过简单的计算可以得到
# 这里测试一下 sys ingress controller + user ingress controller + user app pod
# 能够得到的性能

for pod in 700 600 500 400 200 100 50 25 12; do
    # remove logs files on disk
    # sync cache on the os memory
    /root/init_app_box.sh
    ku scale --replicas=${pod} deployment/test-default-4
    sleep 60

    cp -rf box ips
    date

    dir="${pre}.ingress.svc.${i}.${pod}"
    ./2020-06-28-main.just.ingress.svc.sh ${dir}
    sleep 30

    for ((j=0;j<100;j++)); do
       file=${j}
       ku top pod > ${dir}/${file}
       ku top node > ${dir}/${file}.node
       ks top pod > ${dir}/${file}.sys.pod
       sleep 6
    done
    wait

done

set +o xtrace
