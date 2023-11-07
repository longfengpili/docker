homepage 是一个现代（完全静态、快速）、安全（完全代理）、高度可定制的应用程序仪表板，集成了超过 25 种服务和超过 15 种语言的翻译。可以通过 YAML 文件轻松配置（或通过 docker 标签发现）。下面是homepage的一些特性：

快！整个站点是在构建时静态生成的，因此您可以期待即时加载时间

安全！对后端服务的每个 API 请求都通过代理服务器，因此您的 API 密钥永远不会向前端客户端公开

多平台支持，为 AMD64 （x86_64）、ARM64、ARMv7 和 ARMv6 构建的映像
支持所有Raspberry Pi，大多数SBC和Apple Silicon

完整的i18n支持，翻译加泰罗尼亚语，中文，荷兰语，芬兰语，法语，德语，希伯来语，匈牙利语，马来语，挪威语，波兰语，葡萄牙语，葡萄牙语（巴西），罗马尼亚语，俄语，西班牙语，瑞典语和粤语

服务和网络书签

Docker集成

容器状态（正在运行/已停止）和统计信息（CPU，内存，网络）

自动服务发现（通过标签）

服务集成

集成Sonarr, Radarr, Readarr, Prowlarr, Bazarr, Lidarr, Emby, Jellyfin, Tautulli, Plex 等

集成Ombi，Overseerr，Jellyseerr，Jackett，NZBGet，SABnzbd，ruTorrent，Transmission，qBittorrent等

集成Portainer，Traefik，Speedtest Tracker，PiHole，AdGuard Home， Nginx Proxy Manager,，Gotify，Syncthing Relay Server，Authentik，Proxmox等

信息提供者，Coin Market Cap, Mastodon 等

信息和实用工具小部件

系统统计信息（磁盘、CPU、内存）

天气通过OpenWeatherMap或Open-Meteo

网页搜索栏

UniFi 控制台、概览等

即时“快速启动”搜索

定制

21 种主题颜色，支持浅色和深色模式

背景图像支持

列和行布局选项

老规矩，笔者使用Docker来部署，无非是三板斧：准备、安装和配置，下面逐步介绍：

准备工作
创建应用目录，例如在/share/Container下创建文件夹homepage

在homepage文件夹下再创建config文件夹



NAS上安装好docker-compose

安装Homarr
第一步、 在/share/Container/homepage文件夹下创建文件docker-compose.yml，

第二步、 并将下面内容复制粘贴到docker-compose.yml中，保存：

version: "3.8"
services:
  homepage:
    image: ghcr.io/benphelps/homepage:latest
    container_name: homepage
    restart: unless-stopped
    network_mode: bridge
    environment:
      - PUID=1000
      - PGID=100
      - TZ=Asia/Shanghai
    volumes:
      - /share/Container/homepage/config:/app/config
      - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - 5006:3000
参数说明

参数  说明
-p 3000 http协议访问WebUI的端口，宿主机的端口可以修改成你自己喜欢的
-e PUID=1000    设置PUID的值，请改成自己的
-e PGID=100 设置PGID的值，请改成自己的
-e TZ=Asia/Shanghai 设置时区
-e PASSWORD=123456  设置访问密码
-v /app/config  配置文件的保存位置
-v /var/run/docker.sock docker套接字接口，用于容器状态和自动服务发现等场景
ghcr.io/benphelps/homepage  注意，一定要用这个镜像，dockerhub上的不是官方镜像
第三步、 在NAS的SSH中，切换到homepage文件夹下，执行下面命令启动：

docker-compose up -d
第四步、 等待应用启动完成后，打开WebUI

在浏览器中输入NAS的IP+端口，例如：192.168.31.91:5006

图片
homepage的UI做的很精致，支持明亮和暗黑模式，看着比较舒服。首页默认添加CPU、内存和磁盘状态显示，可以进行快速搜索。

配置homepage
官方在介绍的特性中提到，homepage对Docker和大量第三方应用做了深度集成。但是，homepage不支持在WebUI上进行配置，所有配置都要在配置文件（/app/conifg文件夹中的各种yaml文件）中手工填写，这点还是不够平民化，不过都不是太难理解，看一看官方的文档照着写就行了。

homepage中可配置的内容主要包括服务、服务组件、信息组件、书签、Docker配置、k8s配置和系统配置，零碎的东西非常多，本文就简单对服务、服务组件、信息组件进行简要的说明和示例。

1、配置服务和服务小组件
服务简单理解就是我们要导航的系统或应用，服务都是在一个分组下面的，可以有任意多个分组，每个分组下面可以有任意多个服务。要配置服务，在/app/config/service.yaml文件中添加即可。

例如：添加Group A和Group B两个分组，分别在分组下添加一个服务，服务名称随便写

- Group A:
    - Service A:
        href: http://localhost/
        description: This is my service

- Group B:
    - Service B:
        href: http://localhost/
        description: This is another service
页面上的显示效果：
图片

服务除了基础名称、href（访问地址）、description（描述）属性外，还支持以下属性：

icon，服务图标，可选项
服务的图标支持本地图标文件名、图标链接、Material Design Icons with 或 Simple Icons中的图标代码。如果使用的本地图标，需要将图标放到/app/public/icons文件夹中。例如

- Group A:
    - Sonarr:
        icon: sonarr.png
        href: http://sonarr.host/
        description: Series management

- Group B:
    - Radarr:
        icon: radarr.png
        href: http://radarr.host/
        description: Movie management
        
- Group C:
    - Service:
        icon: mdi-flask-outline
        href: http://service.host/
        description: My cool service
页面上的显示效果：
图片

ping，健康检查链接，可选项
可用于监视服务的可用性并显示响应时间。注意，ping功能的工作原理是向URL发出http请求，并在失败时回退到。例如，如果URL需要身份验证或存在反向代理的情况下，最好设置服务实际的IP来使ping功能正确显示状态。例如：

- Group A:
    - Sonarr:
        icon: sonarr.png
        href: http://sonarr.host/
        ping: http://sonarr.host/

- Group B:
    - Radarr:
        icon: radarr.png
        href: http://radarr.host/
        ping: http://some.other.host/
页面上的显示效果：
图片

server和container，与实际Docker容器集成，可选项
server是指/app/config/docker.yaml文件中定义的docker名称，container是指docker实例中的容器名称。配置后，可以在页面中显示当前docker容器的CPU、内存、网络等信息。例如：

- Group A:
    - Service A:
        href: http://localhost/
        description: This is my service
        server: my-server
        container: my-container

- Group B:
    - Service B:
        href: http://localhost/
        description: This is another service
        server: other-server
        container: other-container
页面上的显示效果：
图片

widget，即服务小组件，可选项
服务可能附加了一个服务小部件（或集成），这些服务小组件是内置在系统中的，具体有哪些小组件可以到官网（https://gethomepage.dev/en/configs/service-widgets/）查看，有一份`AvailableWidgets`列表。例如，我们添加了Radarr和Sonarr服务，这两个服务官方有对应的服务小组件，我们就可以直接添加上，然后就可以直接在页面的服务模块上看到应用的一些信息：

- Group A:
    - Sonarr:
        icon: sonarr.png
        href: http://sonarr.host/
        description: Series management
        widget:
          type: sonarr
          url: http://sonarr.host
          key: apikeyapikeyapikeyapikeyapikey

- Group B:
    - Radarr:
        icon: radarr.png
        href: http://radarr.host/
        description: Movie management
        widget:
          type: radarr
          url: http://radarr.host
          key: apikeyapikeyapikeyapikeyapikey
注意：每个小组件的属性都不一样，一般type和url是通用的，其他属性需要参考官方的详细说明

页面上的显示效果：
图片

2、配置信息小组件
与服务小组件不同，信息小组件是独立的，与服务没有关联，可以单独显示出来。要配置服务，在/app/config/widgets.yaml文件中添加即可。例如，我们将放置两个资源小部件，一个报告所有统计信息，另一个仅报告单独位置的磁盘使用情况。

- resources:
    cpu: true
    memory: true
    disk: /mnt/storage
- resources:
    disk: /mnt/backups
页面上的显示效果：
图片

信息小组件是内置在系统中的，具体有哪些小组件可以到官网（https://gethomepage.dev/en/configs/widgets/）查看，有一份`Available Widgets`列表。

3、配置书签
书签与服务的功能大致相同，即组和列表的工作方式。它们只是更简单，更小，除了作为链接之外不包含任何额外的功能。要配置服务，在/app/config/bookmarks.yaml文件中添加即可。例如添加3个组，每个组下面都添加1个书签：

- Developer:
    - Github:
        - abbr: GH
          href: https://github.com/

- Social:
    - Reddit:
        - icon: reddit.png
          href: https://reddit.com/

- Entertainment:
    - YouTube:
        - abbr: YT
          href: https://youtube.com/
除了书签本身的名称之外，还可以包含3个属性，分别是abbr（名称缩写）、href（连接）和icon（图标），其中abbr和icon可以二选一。

页面上的显示效果：
图片

4、配置Docker集成
前面关于服务和服务组件章节中提到过关于Docker集成的配置，另外服务自动发现也是基于Docker集成来实现，因此要想使用这两个特性，需要先配置好相关的信息才行。

Docker集成相关的配置在在/app/config/widgets.yaml文件中，并且支持跨机/跨实例访问Docker，相当强悍了。例如配置一个Docker实例，名为my-remote-docker，它可以是本机，也可以是另外一台机器，但前提是对应的host和port要正确：

my-remote-docker:
  host: 192.168.0.101
  port: 2375
除了上面基本配置，还支持配置TLS、Socket代理等高级操作，由于很少被用到，本文就不介绍了，感兴趣的朋友建议到官网学习。

5、配置服务标签和服务自动发现
homepage对附加了正确标签的容器具有自动服务发现功能，只需要在启动Docker容器时添加必要的标签即可，这些标签需要以home.开头。例如启动Emby容器时，在启动命令中添加好标签，那么启动后homepage就能自动安装标签的数据添加到homepage的配置中：

services:
  emby:
    image: lscr.io/linuxserver/emby:latest
    container_name: emby
    ports:
      - 8096:8096
    restart: unless-stopped
    labels:
      - homepage.group=Media
      - homepage.name=Emby
      - homepage.icon=emby.png
      - homepage.href=http://emby.home/
      - homepage.description=Media server
其中labels节点下的homepage.xxx等属性就对应homepage服务的属性。

总结
除了以上主要的组件配置之外，homepage还有大量的可配置选项，这些选项可在/app/config/settings.yaml文件中设置，由于实在是太多了，感兴趣的朋友可到官网上查看，本文就不赘述了。

以上就是关于homepage的简单安装和配置过程，笔者折腾过不少导航页应用，对homepage的总体印象仅次于Homarr，在此也强烈推荐。原创不易，如果觉得此文对你有帮助，不妨点赞+收藏+关注，你的鼓励是我最大的动力！
