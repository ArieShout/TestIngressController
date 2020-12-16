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
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import matplotlib.colors as CLS

ps = sys.argv[1]
onlyfiles = [f for f in listdir(ps) if isfile(join(ps, f))]

# 首先去拿到这个目录下所有的文件名
id_list = []
for fn in onlyfiles:
    if fn.find('node') != -1:
        continue
    if fn.find('log') != -1:
        continue
    if fn.find('csv') != -1:
        continue
    if fn.find('.') != -1:
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
            if line.find('nginx') != -1:
                words = line.split()
                pod_name = words[0]
                pod_name_list.add(pod_name)


# 给列表排个序
pod_name_list = list(pod_name_list)
pod_name_list.sort()

# 这里我们依次去打开每个文件
# 把每个pod的结果存放到D{}里面
# D['pod_name'] = [时间顺序的cpu利用率']
D = {}
# 先初始化给每个pod一个list
for pod in pod_name_list:
    D[pod] = []


for i in id_list:
    # 第一列是采样的顺序
    # 然后取得每个pod的情况
    file_name = join(ps, '%s' % i)
    with open(file_name, 'r') as f:
        lines = f.readlines()
        for line in lines:
            if line.find('nginx') != -1:
                # 把句子分成三个部分
                words = line.split()
                pod_name = words[0]
                cpu = words[1].replace('m', '')
                D[pod_name].append(int(cpu))

# 这里拿到数据之后，准备开始画图
# 注意，这里只画ingress的曲线
plt.figure(figsize=(28, 12))
plt.title('Ingress Cpu Usage')

color_list = []
for name,_ in CLS.cnames.iteritems():
    color_list.append(name)

color_iter = 0
for pod in pod_name_list:
    name = pod.split('-')[-1]
    plt.plot(id_list, D[pod], color=color_list[color_iter], label=name)
    color_iter = (color_iter + 1) % len(color_list)

plt.legend() # 显示图例
plt.xlabel('sample times')
plt.ylabel('cpu usage')

fig = plt.gcf()
fig.savefig(join(ps, 'ingress.svg'), dpi=300)
