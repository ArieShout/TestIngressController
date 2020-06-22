#!/bin/bash

set -e

dir="$1"

mkdir -p $dir

for n in `cat ips`; do

	nohup ssh azureuser@${n} \
	"wrk -t 1 -c 300 -d 600s --latency -H 'Connection: Close' http://10.0.63.193:1025" | \
	 tee ${dir}/log.${n}.t.1.c.300.log &

done
