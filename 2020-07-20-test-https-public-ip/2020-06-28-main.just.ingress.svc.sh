#!/bin/bash

# 这里只是从ingress的svc发送请求，是不会走ingress相关的lb过
# add dns record yoj-ingress-svc.zihchdomains.com -> 10.0.43.35 ClusterIP A record in dns server.

set -e

fold="$1"
mkdir -p ${fold}

for n in `cat ips`; do

	nohup ssh azureuser@${n} \
	"wrk -t 1 -c 100 -d 600s --latency https://yoj-perf-test.test.asc-test.net" | \
	 tee ${fold}/log.${n}.t.1.c.300.log &

done
