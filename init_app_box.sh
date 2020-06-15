#!/bin/bash

# 用来清理节点上占用空间太大的文件
ku get node -o wide | grep -v Sch | awk '{print $6}' | grep 10 > /root/app_nodes
cat /root/app_nodes | xargs -i /root/pass-cp /root/del-files {}
cat /root/app_nodes | xargs -i /root/run.cmd.sh {}
