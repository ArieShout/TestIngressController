#!/bin/bash



set -e

fold="$1"
mkdir -p ${fold}

for n in `cat ips`; do

	nohup ssh azureuser@${n} \
	"wrk -t 1 -c 100 -d 600s --latency https://yoj-perf-test.test.asc-test.net" | \
	 tee ${fold}/log.${n}.t.1.c.300.log &

done
