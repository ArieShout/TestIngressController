#!/usr/bin/env python
# -*- coding: utf-8 -*-


"""
这个脚本只处理单轮的数据，并且把单轮的数据生成一个csv
每一个轮的数据大概会有100采样点，里面记录了每个pod的cpu/mem利用率。
"""


import sys
import json
import os
from os import listdir
from os.path import isfile, join

ps = sys.argv[1]
onlyfiles = [f for f in listdir(ps) if isfile(join(ps, f))]

# 首先去拿到这个目录下所有的文件名
id_list = []
for fn in onlyfiles:
    if fn.find('node') != -1:
        continue
    if fn.find('log') != -1:
        continue

    id_list.append(int(fn))

id_list.sort()


"""
这里我们只统计这两种pod的cpu/mem利用率
nginx-ingress-controller-7c5b796c78-zvb9j   211m         76Mi
nginx-ingress-controller-7c5b796c78-zvzs4   210m         74Mi
prometheus-server-79c577d6d6-x4ql9          48m          207Mi
test-default-4-5cdb95c955-22zps             1000m        716Mi
test-default-4-5cdb95c955-275l7             1001m        638Mi
"""

# 拿到pod_name的列表
pod_name_list = set()
for i in id_list:
    file_name = join(ps, '%s' % i)
    with open(file_name, 'r') as f:
        lines = f.readlines()
        for line in lines:
            if line.find('nginx') == -1 and line.find('test-default-4') == -1:
                continue
            # 把句子分成三个部分
            words = line.split()
            pod_name = words[0]
            pod_name_list.add(pod_name)


# 给列表排个序
pod_name_list = list(pod_name_list)
pod_name_list.sort()

for i in id_list:
    # 第一列是采样的顺序
    # 然后取得每个pod的情况
    D = {}
    file_name = join(ps, '%s' % i)
    with open(file_name, 'r') as f:
        lines = f.readlines()
        for line in lines:
            if line.find('nginx') == -1 and line.find('test-default-4') == -1:
                continue
            # 把句子分成三个部分
            words = line.split()
            pod_name = words[0]
            cpu = words[1].replace('m', '')
            # 内存的暂时不要
            # mem = words[2].replace('Mi', '')
            D[pod_name] = cpu

    # 输出是第几次采样
    print  "%s," % i,

    for name in pod_name_list:
        print "%s," % D[name],
    print ""
