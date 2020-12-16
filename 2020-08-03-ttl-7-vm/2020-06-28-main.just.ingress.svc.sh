#!/bin/bash



set -e

fold="$1"
mkdir -p ${fold}

wrk -t 1 -c 10000 -d 600s --latency https://yoj-perf-test2-test.asc-test.net  | tee ${fold}/log.100.600.log &
