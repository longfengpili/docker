# [简介](https://help.tableau.com/current/server-linux/zh-cn/server-in-container_quickstart.htm)
“容器中的 Tableau Server”是 Tableau 的第一款基于容器的服务器产品。“容器中的 Tableau Server”是在 Linux Docker 容器内运行的一体化 Tableau Server 实例。换句话说，“容器中的 Tableau Server”是运行整个自包含 Tableau Server 应用程序的 Docker 映像。“容器中的 Tableau Server”是我们为在基于容器的环境中运行的 Tableau Server 提供支持的许多步骤中的第一个步骤。了解“容器中的 Tableau Server”概念的最简单方法是将其看作一个预装了 Tableau Server 的 VM。映像以 UBI 8 映像（适用于版本 2022.1 及更低版本的 CentOS 7.x）为基础，并在容器内运行 supervisord（而不是 systemd）。容器启动 supervisord 后，将立即尝试初始化和启动 Tableau Server。此处的大部分文档旨在描述如何提供配置和利用自动化，以便您可以在 Docker 环境中运行 Tableau Server。  

“容器中的 Tableau Server”映像设置工具可帮助您创建和自定义容器映像以包括自定义包和项目。该工具的主要功能之一是构建容器映像并安装自定义数据连接器。

# 限制
+ “容器中的 Tableau Server”仅支持使用 Server ATR 的许可证激活，这要求容器具有 Internet 访问权限。因此，无法在隔离网络的环境中进行脱机激活。
+ “容器中的 Tableau Server”当前不支持 Resource Monitoring Tool (RMT) 代理。
+ “容器中的 Tableau Server”不支持 Kerberos。


# “容器中的 Tableau Server”设置工具
“容器中的 Tableau Server”设置工具 build-image 可依据 Tableau .rpm 安装程序和提供的配置文件构建“容器中的 Tableau Server”自定义映像。  

设置工具将 Tableau Server 安装程序和驱动程序以及其他项目作为输入，并创建 Docker 映像。当正确使用 build-image 工具时，新生成的映像将安装所需的项目。

# 支持的构建发行版
仅在基于 RHEL 的 Linux 系统（RHEL、CentOS 或 Amazon Linux 2）上支持构建“容器中的 Tableau Server”Docker 映像。在任何其他 Linux 发行版上进行构建是也许可行，但目前未经测试且不受支持。不支持在 macOS 上构建映像。创建的映像基于 UBI 8映像（对于版本 2022.1 及更低版本为 CentOS 7.x）。

您必须使用包含 Docker 版本 17 或更高版本的发行版，并首选最新版本的 Docker。低于版本 17 的 Docker 版本不包含“容器中的 Tableau Server”所需的功能。

# 下载必要的文件
若要使用设置工具，您需要下载该工具和兼容的 Server 安装程序 .rpm 文件。安装程序文件必须是版本 2021.2.0 或更高版本。这两个文件都可以从[Tab
leau Server 页面](https://www.tableau.com/zh-cn/support/releases/server) 下载。
+ 下载 Server 安装程序文件 tableau-server-<version>.rpm 版本 2021.2.0 或更高版本。
+ 下载“容器中的 Tableau Server”设置工具 tableau-server-container-setup-tool-<version>.tar.gz。

# 安装
“容器中的 Tableau Server”设置工具以压缩包形式提供。您将需要提取压缩文件的内容。下面是一个示例，该示例假定“容器中的 Tableau Server”设置工具存档位于当前目录中：  
`tar -xzf tableau-server-container-setup-tool-<VERSION>.tar.gz`  
这将创建一个新目录 tableau-server-container-setup-tool-<VERSION>，其中包含用于运行工具的 build-image 脚本

