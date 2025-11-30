# supervisor

`/etc/systemd/system/redis_6379.service`

```conf
[Unit]
Description=Redis server
Documentation=https://redis.io/documentation
#Before=your_application.service another_example_application.service
#AssertPathExists=/var/lib/redis
Wants=network-online.target
After=network-online.target

[Service]
Environment="REDIS_CONF_FILE=/home/m/redis/6379/redis.conf"
Environment="REDISCLI_AUTH=$(grep '^requirepass' ${REDIS_CONF_FILE} | awk '{print $2}')"
Environment="REDISCLI_PORT=$(grep '^\s*port' ${REDIS_CONF_FILE} | awk '{print $2}' || echo '6379')"

#ExecStart=/usr/local/bin/redis-server --supervised systemd --daemonize no
## Alternatively, have redis-server load a configuration file:
ExecStart=/home/m/redis/redis-server ${REDIS_CONF_FILE} --supervised systemd
ExecStop=/home/m/redis/redis-cli -p {REDIS_PORT} shutdown
ExecReload=/home/m/redis/redis-cli -p {REDIS_PORT} CONFIG REWRITE

# 配置 notify 需要 redis 编译前安装 systemd-devel pkg-config, 否则配置 simple
Type=notify
LimitNOFILE=10032
NoNewPrivileges=yes
#OOMScoreAdjust=-900
#PrivateTmp=yes
TimeoutStartSec=60
TimeoutStopSec=10
UMask=0077
#User=redis
#Group=redis
#WorkingDirectory=/var/lib/redis

[Install]
# root systemd
WantedBy=multi-user.target
# user systemd
; WantedBy=default.target
```

multiple servers

```conf
[Unit]
Description=Redis server - instance %i
Documentation=https://redis.io/documentation
# This template unit assumes your redis-server configuration file(s)
# to live at /etc/redis/redis_server_<INSTANCE_NAME>.conf
AssertPathExists=/etc/redis/redis_server_%i.conf
#Before=your_application.service another_example_application.service
#AssertPathExists=/var/lib/redis

[Service]
ExecStart=/usr/local/bin/redis-server /etc/redis/redis_server_%i.conf

# 配置 notify 需要 redis 编译前安装 systemd-devel pkg-config, 否则配置 simple
Type=notify
LimitNOFILE=10032
NoNewPrivileges=yes
#OOMScoreAdjust=-900
#PrivateTmp=yes
TimeoutStartSec=60
TimeoutStopSec=10
UMask=0077
#User=redis
#Group=redis
#WorkingDirectory=/var/lib/redis

[Install]
# root systemd
WantedBy=multi-user.target
# user systemd
; WantedBy=default.target
```

`redis.conf`

```redis
bind 0.0.0.0
port 6379

daemonize no
supervised auto

pidfile /home/m/redis/6379/redis.pid
logfile /home/m/redis/6379/redis.log

dbfilename dump.rdb
dir /home/m/redis/6379

requirepass xxx

loadmodule /home/m/redis/modules/redisbloom.so
loadmodule /home/m/redis/modules/redisearch.so
loadmodule /home/m/redis/modules/rejson.so
loadmodule /home/m/redis/modules/redistimeseries.so
```
