#!/bin/bash

#sed -i "/lifecycle-integration-test-rpv3-test.asc-test.net/d" /etc/hosts
#echo 10.0.43.35  lifecycle-integration-test-rpv3-test.asc-test.net >> /etc/hosts
#
#sed -i "/yoj-user-aks-lb.zihchdomains.com/d" /etc/hosts
#echo 10.12.0.6 yoj-user-aks-lb.zihchdomains.com >> /etc/hosts
#
#sed -i "/yoj-perf.zihchdomains.com/d" /etc/hosts
#echo "10.0.43.35 yoj-perf.zihchdomains.com" >> /etc/hosts

# install node-exporter
if [[ ! -e /opt/node-exporter ]]; then
    cd /tmp/
    wget https://github.com/prometheus/node_exporter/releases/download/v1.0.0/node_exporter-1.0.0.linux-amd64.tar.gz
    tar zxf node_exporter-1.0.0.linux-amd64.tar.gz
    mv node_exporter-1.0.0.linux-amd64/node_exporter /opt/
    cat <<"EOF"> //lib/systemd/system/node-exporter.service
[Unit]
Description=node_exporter
Documentation=https://prometheus.io/
After=network.target
[Service]
Type=simple
User=root
ExecStart=/opt/node_exporter
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl start node-exporter
    ps aux | grep node-exporter
fi

# change max file opened for ingress controller

if [[ `cat /etc/security/limits.conf | grep 65535 | wc -l` -eq 0 ]]; then
    cat <<"EOF">>/etc/security/limits.conf
* soft nofile 65535
* hard nofile 65535
EOF
fi

# change network performance settings

if [[ `cat /etc/sysctl.conf | grep 16777216 | wc -l` -eq 0 ]]; then

cat <<"EOF">> /etc/sysctl.conf
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_syncookies = 1
# this gives the kernel more memory for tcp
# which you need with many (100k+) open socket connections
net.ipv4.tcp_mem = 50576   64768   98152
net.core.netdev_max_backlog = 2500
# I was also masquerading the port comet was on, you might not need this
#net.ipv4.netfilter.ip_conntrack_max = 1048576

fs.file-max=50000000000
fs.nr_open =200000
EOF
sysctl -p
fi
