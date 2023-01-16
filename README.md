"# docker" 


+ 容器中访问docker
```docker
    volumes:
      - type: bind
        source: /var/run/docker.sock
        # source: //var/run/docker.sock  # windows
        target: /var/run/docker.sock
      - type: bind  # if not work, can delete this bind
        source: /usr/bin/docker
        target: /usr/bin/docker
```
+ 增加root
```docker
user: root
```
+ 