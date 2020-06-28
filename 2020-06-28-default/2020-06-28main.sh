#!/bin/bash

set -o xtrace
pre="2020-06-28-default"

# 主要是担心客户端数量不够，在hash的时候，请求分发得不是很均匀，所以这里增加了很多客户端的数量
# 变量：客户端的数量
# 固定的是 ingress = 120
# app pod = 400

for pod in 400; do
    # remove logs files on disk
    # sync cache on the os memory
    /root/init_app_box.sh
    ku scale --replicas=${pod} deployment/test-default-4
    sleep 60

    # 这里调整 ingress controller的pod的数量
    for ((i=180;i >= 10;i-=4)); do
        cat box | head -i > ips
        date
        /root/init_app_box.sh

        # 只调用ingress svc, 采用default configmap的配置
        sleep 50
        dir="${pre}.ingress.svc.${i}.${pod}"
        ./2020-06-28-main.just.ingress.svc.sh ${dir}
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
