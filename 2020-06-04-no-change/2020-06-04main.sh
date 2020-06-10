#!/bin/bash

set -o xtrace
pre="2020-06-04-no-change"

# 这里主要是测试没有任何更改的情况下，app.svc和ingress.svc的性能

for pod in 400 380 340 300 280 240 200 160 120 80 40 20 10; do
    ku scale --replicas=${pod} deployment/test-default-4
    sleep 60

    for ((i=0;i<4;i++)); do

        date
        echo ${pod} ${i} in this round

        # 只调用pod svc
        dir="${pre}.pod-svc.${i}.${pod}"
        ./2020-06-04-main.pod.svc.sh ${dir}
        sleep 30
        for ((j=0;j<100;j++)); do
           file=`date | tr " " "-" | tr ":" "-"`
           ku top pod > ${dir}/${file}
           sleep 6
        done
        wait

        # 只调用ingress svc, 采用default configmap的配置
        sleep 50
        dir="${pre}.ingress.svc.${i}.${pod}"
        ./2020-06-04-main.just.ingress.svc.sh ${dir}
        sleep 30
        for ((j=0;j<100;j++)); do
           file=`date | tr " " "-" | tr ":" "-"`
           ku top pod > ${dir}/${file}
           sleep 6
        done
        wait
    done
done

set +o xtrace
