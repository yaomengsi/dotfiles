# ipv4
# netsh interface portproxy add v4tov4 listenport=80 listenaddress=0.0.0.0 connectport=80 connectaddress=192.168.116.66
# netsh interface portproxy add v4tov4 listenport=443 listenaddress=0.0.0.0 connectport=443 connectaddress=192.168.116.66
# ipv6
# mirrored 模式下端口不能一样, host 到 wsl2 的 ipv6 有问题
netsh interface portproxy add v6tov4 listenport=80 listenaddress=:: connectport=8080 connectaddress=127.0.0.1
netsh interface portproxy add v6tov4 listenport=443 listenaddress=:: connectport=8443 connectaddress=127.0.0.1
# NAT 模式下 wsl2 有单独的 ip
# netsh interface portproxy add v6tov4 listenport=80 listenaddress=:: connectport=80 connectaddress=192.168.116.66
# netsh interface portproxy add v6tov4 listenport=433 listenaddress=:: connectport=433 connectaddress=192.168.116.66

netsh interface portproxy show all
# netsh interface portproxy reset

# 所有的外部访问的端口 和 portproxy 目标端口都要添加到防火墙规则中
netsh advfirewall firewall add rule name="0_allow_extenal_access_wsl2_port" dir=in action=allow protocol=TCP localport=80,443,8080,8443
# windows wsl
netsh advfirewall firewall add rule name="0_allow_extenal_sunshine_udp" dir=in action=allow remoteip=192.168.0.0/16,172.20.0.0/16 protocol=TCP localport=any
netsh advfirewall firewall add rule name="0_allow_extenal_sunshine_tcp" dir=in action=allow protocol=TCP localport=47984,47989,47990,48010,47998-48000
netsh advfirewall firewall add rule name="0_allow_extenal_sunshine_udp" dir=in action=allow protocol=UDP localport=47984,47989,47990,48010,47998-48000
