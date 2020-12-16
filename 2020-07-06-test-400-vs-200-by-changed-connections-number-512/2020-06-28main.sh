#!/bin/bash

set -o xtrace
pre="cons-512"


# 实验目的：
# 在缺省的keep_alive_connections = 32的时候，通过简单的计算可以得到
# 一共120个ingress pod，每个pod 32个链接,那么一共有3840个链接
# 可以按照 4k来算。然后由于90%的请求都是25ms，那么取25ms一个请求。
# 1000ms一个链接可以处理40个request, 此时得到~=16W RPS
#  Thread Stats   Avg      Stdev     Max   +/- Stdev
#    Latency    58.56ms  224.89ms   2.00s    94.17%
#    Req/Sec     1.52k   496.08     9.50k    71.97%
#   Latency Distribution
#     50%    4.74ms
#     75%    8.91ms
#     90%   25.38ms
#     99%    1.32s
# 因此，这里把请求的链接数直接上调到1000。然后再看一下不同的pod的数量能够提供的
# RPS
# 变量：客户端的数量
# 固定的是 ingress = 120
# app pod = 400, 200, 100, 50, 25 12

for pod in 400 200 100 50 25 12; do
    # remove logs files on disk
    # sync cache on the os memory
    /root/init_app_box.sh
    ku scale --replicas=${pod} deployment/test-default-4
    sleep 60

    # 这里调整Ingress controller的数量
    for ((i=120;i >= 2;i-=4)); do
        cp -rf box ips
        date
        /root/init_app_box.sh

        # 设置ingress controller pod数量
        ku scale --replicas=${i} deployment/nginx-ingress-controller
        # 只调用ingress svc, 采用default configmap的配置
        sleep 20

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

    done
done

set +o xtrace
