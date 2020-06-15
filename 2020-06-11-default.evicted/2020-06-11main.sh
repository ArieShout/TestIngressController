#!/bin/bash

set -o xtrace
pre="2020-06-11-default"

# 这里主要是测试没有任何更改的情况下，app.svc在不同的客户端情况下的性能

for pod in 400 200 100 10 10; do
    # remove logs files on disk
    # sync cache on the os memory
    /root/init_app_box.sh
    ku scale --replicas=${pod} deployment/test-default-4
    sleep 60
    for ((i=1;i<=50;i+=3)); do
        cat box | head -${i} > ips
        date
        echo ${pod} ${i} in this round

        # 只调用pod svc
        dir="${pre}.pod-svc.${i}.${pod}"
        ./2020-06-11-main.pod.svc.sh ${dir}
        sleep 30
        for ((j=0;j<100;j++)); do
           file=${j}
           ku top pod > ${dir}/${file}
           ku top node > ${dir}/${file}.node
           sleep 6
        done
        wait
        /root/init_app_box.sh

        # 只调用ingress svc, 采用default configmap的配置
        sleep 50
        dir="${pre}.ingress.svc.${i}.${pod}"
        ./2020-06-11-main.just.ingress.svc.sh ${dir}
        sleep 30
        for ((j=0;j<100;j++)); do
           file=${j}
           ku top pod > ${dir}/${file}
           ku top node > ${dir}/${file}.node
           sleep 6
        done
        wait
        /root/init_app_box.sh
    done
done

set +o xtrace
