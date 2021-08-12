##### elasticsearch.yml配置如下

```
network.host: 0.0.0.0
network.bind_host: 0.0.0.0  #外网可访问

http.cors.enabled: true
http.cors.allow-origin: "*"
xpack.security.enabled: true # 这条配置表示开启xpack认证机制
xpack.security.transport.ssl.enabled: true
```

| xpack.security配置后，elasticsearch需要账号密码使用。

---

##### 初始化密码

此项仅在上文xpack配置的情况下才需要执行，首先进入容器命令行，然后直行初始化命令：

```
docker exec -it 容器id /bin/bash
bin/elasticsearch-setup-passwords interactive
```
| 然后依次输入密码

---

##### 验证

访问ip:9200，如果上文开启了xpack.security，需要输入账号密码。
账号/密码：elastic/上文设置的密码