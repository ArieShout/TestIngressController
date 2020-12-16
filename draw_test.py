
# -*- coding: UTF-8 -*-
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt

x_axix = [1,2,3]
Y1 = [1,2,3]
Y2 = [2,3,4]
Y3 = [3,4,5]

#开始画图
plt.title('Result Analysis')
plt.plot(x_axix, Y1, color='green', label='training accuracy')
plt.plot(x_axix, Y2,  color='skyblue', label='PN distance')
plt.plot(x_axix, Y3, color='blue', label='threshold')

plt.legend() # 显示图例
plt.xlabel('iteration times')
plt.ylabel('rate')

fig = plt.gcf()
fig.savefig('test.svg')
#plt.show()
