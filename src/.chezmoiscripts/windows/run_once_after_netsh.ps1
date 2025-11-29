# ipv4
# netsh interface portproxy add v4tov4 listenport=80 listenaddress=0.0.0.0 connectport=80 connectaddress=192.168.116.66
# netsh interface portproxy add v4tov4 listenport=443 listenaddress=0.0.0.0 connectport=443 connectaddress=192.168.116.66
# ipv6
# mirrored 模式下端口不能一样, host 到 wsl2 的 ipv6 有问题
netsh interface portproxy add v6tov4 listenport=80 listenaddress=:: connectport=8080 connectaddress=127.0.0.1
netsh interface portproxy add v6tov4 listenport=443 listenaddress=:: connectport=8443 connectaddress=127.0.0.1
# NAT 模式下 wsl2 有单独的 ip
netsh interface portproxy add v6tov4 listenport=80 listenaddress=:: connectport=80 connectaddress=192.168.116.66
netsh interface portproxy add v6tov4 listenport=433 listenaddress=:: connectport=433 connectaddress=192.168.116.66

netsh interface portproxy show all
# netsh interface portproxy reset

# netsh advfirewall firewall add rule name="Allow WSL2 Port 8010" dir=in action=allow protocol=TCP localport=8010
