# 各脚本的作用

add_host: 如果我想绕过LB，直接把流量打到ingress，再通过ingress把流量打到用户的app，那么这个时候，就需要将ip与ingress rule里面的hostname直接写在/etc/hosts里面。

aks-ssh: 创建ssh pod到指定的结点上。现在ssh到aks node的方式已经变了，这条路已经走不通了，deprecated.
install-node-exporter.sh: 在aks node上安装node exporter可以采集aks node上的各种性能指标
del-files: 在大流量压测下，aks node会产生较多的日志文件，需要清理
disable: disable某个aks node
enable: enable某个aks node
get_pod_loc: 拿到某个pod所在的aks node
install_wrk: 批量在client端结点上安装wrk
ks: k8s client command alias for system
ku: k8s client command alias for user aks cluster
load-test.ingres.yml: 手动建ingress rule引流到自己的app example
lua.script: wrk支持lua script来统计出错情况。比如使用-s参数。
max-open-files: 设置系统最大打开文件数
netpar: 调整网络参数
ospar: 调整os parameter作为网络应用服务器。统一参数全都调了。
run.cmd.sh: 远程到aks node上sudo 执行cmd脚本。
scs/scu: 调整pod数量的脚本
single_csv.py: 将一个目录下的所有的文件整理成csv文件。
single_csv_ingress.py: 将一个目录下所有的性能统计整理成csv文件。只关心ingress pod。
user-aks/sys-aks: k8s客户端setup脚本。
yoj-test-con-pod.yml: nginx作为客户端测试流量app

single_draw_ingress_graph.py: 利用拿到的node/pod的cpu/mem的消耗数据画曲线
single_draw_user_app_graph.py：利用拿到的node/pod的cpu/mem数据画曲线。运行方式是： python single_draw_user_app_graph.py ./2020-06-28-default/2020-06-28-default.ingress.svc.180.400

