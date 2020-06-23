#!/bin/bash

set -o xtrace
pre="2020-06-22-default"

# 这里主要是测试没有任何更改的情况下，ingress.svc在不同的ingress controller数量下
# 做这个测试的原因是，在1-50个节点的情况下，发现ingress.svc的性能在随着node数量增加的情况下
# 看一下性能是不是还会涨?

for pod in 400 200 100; do
    # remove logs files on disk
    # sync cache on the os memory
    /root/init_app_box.sh
    ku scale --replicas=${pod} deployment/test-default-4
    sleep 60

    # 这里调整 ingress controller的pod的数量
    for ((i=120;i >= 10;i-=4)); do
        cp -rf box ips
        date
        echo ${pod} ${i} in this round

        # 这里删除多余的ingress controller
        ku scale --replicas=${i} deployment/nginx-ingress-controller
        sleep 60

        /root/init_app_box.sh

        # 只调用ingress svc, 采用default configmap的配置
        sleep 50
        dir="${pre}.ingress.svc.${i}.${pod}"
        ./2020-06-22-main.just.ingress.svc.sh ${dir}
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
