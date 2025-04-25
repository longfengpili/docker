以下是合并后的 **Ollama API 文档与介绍**，整合了 [GitHub README](https://github.com/ollama/ollama) 和 [API 文档](https://github.com/ollama/ollama/blob/main/docs/api.md) 的核心内容：

---

# Ollama

**Ollama** 是一个开源的本地大语言模型（LLM）运行框架，支持快速部署和管理多种开源模型（如 Llama 3、Mistral、CodeLlama 等）。它提供了简单的命令行工具和 REST API，支持模型加载、生成文本、多轮对话、嵌入生成等功能。

---

## 1. 核心功能

1. **本地运行模型**  
   - 无需云端依赖，完全离线使用。
   - 支持量化模型（如 `Q4_0`, `Q5_K_M`），降低硬件需求。
   - 自动处理模型下载和依赖。

2. **多平台支持**  
   - macOS、Linux、Windows（预览版）。
   - Docker 容器化部署。

3. **丰富的模型库**  
   - 官方模型库：[ollama.com/library](https://ollama.com/library)
   - 支持自定义模型（通过 `Modelfile`）。

4. **开发者友好**  
   - 提供命令行工具和 REST API。
   - 支持流式响应、结构化输出、多模态输入（如图片）。

---

## 2. 命令行使用

### 基础命令

| 命令       | 参数               | 示例                          | 说明                                   |
|------------|--------------------|-------------------------------|----------------------------------------|
| `run`      | `<模型名> [提示语]` | `ollama run llama3`           | 运行指定模型                           |
| `pull`     | `<模型名>[:版本]`  | `ollama pull mistral`         | 下载模型                               |
| `list`     | `--json`           | `ollama list --json`          | 列出本地模型（支持JSON格式输出）       |
| `rm`       | `<模型名>`         | `ollama rm codellama`         | 删除模型                               |
| `create`   | `-f <Modelfile>`   | `ollama create mymodel -f ./Modelfile` | 从Modelfile创建自定义模型 |
| `cp`       | `<源模型> <目标模型>` | `ollama cp llama3 my-llama` | 复制模型                              |
| `push`     | `<用户名/模型名>`   | `ollama push myuser/llama3-cn` | 推送模型到私有仓库                   |
| `serve`    | `--host <IP>`      | `ollama serve --host 0.0.0.0` | 启动后台服务                         |
| `ps`       | `-q`               | `ollama ps -q`                | 查看运行中的模型                     |
| `stop`     | `<模型名>`         | `ollama stop llama3`          | 终止运行中的模型实例                 |
| `show`     | `--license <模型名>` | `ollama show --license mistral` | 显示模型详细信息                   |
| `help`     | `[命令]`           | `ollama help create`          | 查看命令帮助                         |

### 常用工作流示例

```bash
# 基础使用
ollama pull llama3 && ollama run llama3 "用中文解释量子力学"

# 模型管理
ollama create custom-llama -f Modelfile
ollama cp custom-llama backup-llama
ollama push myrepo/backup-llama

# 系统管理
ollama serve &  # 启动后台服务
ollama ps       # 查看运行状态
```

## 3. [模型库](https://ollama.com/search)

### 预置模型示例

| 模型名称       | 参数大小 | 内存需求 | 特点               |
|----------------|----------|----------|--------------------|
| Llama 3        | 8B/70B   | 8GB/64GB | Meta最新开源模型    |
| Mistral        | 7B       | 8GB      | 法语优化           |
| Gemma 2        | 2B/27B   | 4GB/32GB | Google轻量级模型    |
| CodeLlama      | 7B       | 8GB      | 代码生成专用        |

### 硬件建议
- 7B模型：≥8GB RAM
- 13B模型：≥16GB RAM
- 70B+模型：需要64GB+ RAM和GPU加速

## 4. 自定义与扩展

### 创建自定义模型

1. 编写Modelfile：
```dockerfile
FROM llama3
PARAMETER temperature 0.7
SYSTEM "你是一个专业的医学助手"
```

2. 构建运行：
```bash
ollama create med-llama -f Modelfile
ollama run med-llama
```

### 5. 使用 [API](https://github.com/ollama/ollama/blob/main/docs/api.md)
启动 Ollama 服务后，默认监听 `http://localhost:11434`。

#### 生成文本
```bash
curl http://localhost:11434/api/generate -d '{
  "model": "llama3",
  "prompt": "为什么天空是蓝色的？",
  "stream": false
}'
```

#### 多轮聊天
```bash
curl http://localhost:11434/api/chat -d '{
  "model": "llama3",
  "messages": [
    { "role": "user", "content": "你好！" }
  ]
}'
```

---

## 社区与支持

- **GitHub**: [github.com/ollama/ollama](https://github.com/ollama/ollama)
- **文档**: [ollama.com/docs](https://ollama.com/docs)
- **模型库**: [ollama.com/library](https://ollama.com/library)

---

## 示例应用

### 1. 本地知识问答
```bash
ollama run llama3 "用中文解释量子计算"
```

### 2. 代码生成
```bash
ollama run codellama "写一个 Python 快速排序函数"
```

### 3. 嵌入搜索
```python
import requests
response = requests.post(
  "http://localhost:11434/api/embed",
  json={"model": "all-minilm", "input": "如何学习机器学习？"}
)
print(response.json()["embeddings"])
```

