#!/bin/bash

set -o xtrace
pre="2020-06-18-default"

# 这里测试TPS
# 每次测试完之后，会把connection关掉

for pod in 400 200 100 10;  do
    # remove logs files on disk
    # sync cache on the os memory
    /root/init_app_box.sh
    ku scale --replicas=${pod} deployment/test-default-4
    sleep 60
    for ((i=2;i<=80;i+=2)); do
        cat box | head -${i} > ips
        date
        echo ${pod} ${i} in this round

        # 只调用pod svc, 由于pod在客户端增加到一定程度之后不再增长，所以以这里不需要要再做这个实验
        dir="${pre}.pod-svc.${i}.${pod}"
        ./2020-06-18-main.pod.svc.sh ${dir}
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
        ./2020-06-18-main.just.ingress.svc.sh ${dir}
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
