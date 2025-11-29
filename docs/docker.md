# docker

/etc/docker/daemon.json

```json
{
  "registry-mirrors": [
    // "https://xxx.mirror.aliyuncs.com",
    "https://docker.mirrors.ustc.edu.cn/",
    "https://hub-mirror.c.163.com",
    "https://registry.docker-cn.com"
  ]
}
```

/etc/systemd/system/docker.service.d/proxy.conf

```ini
[Service]
# HTTP/HTTPS 代理
Environment="HTTP_PROXY=http://192.168.112.1:3067"
Environment="HTTPS_PROXY=http://192.168.112.1:3067"

# 排除代理的内网地址/域名（重要！）
Environment="NO_PROXY=localhost,127.0.0.1,::1,10.*,*.your-company.com,docker-registry.example.com"
```
