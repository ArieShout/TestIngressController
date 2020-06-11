#!/bin/bash

# 用来清理节点上占用空间太大的文件

cat box | xargs -i ./pass-cp del-files {}
cat box | xargs -i ./run.cmd.sh {}
