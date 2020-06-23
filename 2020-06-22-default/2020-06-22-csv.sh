#!/bin/bash

pre="2020-06-16-default"

# 这里主要是测试没有任何更改的情况下，ingress.svc在不同的客户端情况下的性能
# 做这个测试的原因是，在1-50个节点的情况下，发现ingress.svc的性能在随着node数量增加的情况下
# 看一下性能是不是还会涨?

for ((i=2;i<=80;i+=2)); do
    echo -n ${i},
for pod in 10 100 200 400; do
        dir="${pre}.ingress.svc.${i}.${pod}"
        val=`cat $dir/*.log | grep Request | awk '{print $2}' | paste -s -d+ | bc`
#        echo ${pod} ${i} ${val}
        echo -n ${val},
    done
    echo ""
done
