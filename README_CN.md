# 万兴PDF AI 技能（PDFelement AI Skill）

> **作者：** 万兴PDF AI 团队（PDFelement AI Team）· **组织：** Wondershare PDFelement（万兴PDF）  
> **版本：** 1.1.0 · **许可证：** MIT License © 2026 Wondershare PDFelement（万兴PDF）。

这是一个面向 AI Agent（如: OpenClaw, Claude Code等）的 AI 技能（Skill），通过本地安装的 PDFelement 工具箱执行 PDF 批量处理操作。

---

## 技能简介

`pdfelement-skill` 技能让您通过自然语言指令，使用本地 PDFelement 应用程序批量处理 PDF 文件。支持转换、OCR、压缩、翻译、水印、安全加密、拆分合并等 20+ 种 PDF 操作。

### 支持的操作类型

| 操作类型 | 适用场景 | 命令 |
|---|---|---|
| **格式转换** | PDF 转 Word、Excel、PPT、图片、文本等 | `convert` |
| **数据提取** | 从表单或表格中提取数据 | `dataExtract` |
| **压缩优化** | 减小 PDF 文件大小 | `optimize` |
| **OCR识别** | 扫描件文字识别 | `ocr` |
| **翻译** | PDF 文档翻译 | `translate` |
| **水印** | 添加水印 | `watermark` |
| **背景** | 添加背景 | `background` |
| **页眉页脚** | 添加页眉或页脚 | `headerFooter` |
| **贝茨编号** | 添加贝茨编号 | `batesNumber` |
| **安全加密** | 设置密码或权限 | `security` |
| **批量打印** | 批量打印 PDF | `batchPrint` |
| **删除空白页** | 删除空白页 | `deleteBlankPages` |
| **签名** | 添加签名 | `sign` |
| **拆分** | 拆分 PDF | `split` |
| **合并** | 合并 PDF | `combine` |
| **裁剪** | 裁剪页面 | `crop` |
| **创建** | 创建 PDF | `create` |

### 解决什么问题

- **本地化处理** — 所有 PDF 操作在本地完成，无需上传文件到云端，保护隐私和数据安全。
- **批量自动化** — 通过命令行接口批量处理多个 PDF 文件，提高工作效率。
- **AI 自然语言控制** — 用自然语言描述需求，AI 自动选择正确的工具和参数执行任务。
- **专业 PDF 能力** — 支持 OCR、翻译、数据提取等高级 PDF 处理功能。

---

## 系统要求

### Windows
- **PDFelement 12.1.14 或更高版本** 必须已安装
- 系统必须注册 `wspet://` 自定义协议
- 需要在用户桌面会话中运行

### Linux (Ubuntu)
- **PDFelement** 必须安装在 `/opt/apps/PDFelement`
- 需要图形化桌面环境（X11 或 Wayland）
- 需要设置 `DISPLAY` 环境变量

---

## 安装方法

### 1. 安装 PDFelement

**下载地址：** https://pdf.wondershare.com/

- Windows: 安装 PDFelement 12.1.14 或更高版本
- Linux: 按照官方说明安装到 `/opt/apps/PDFelement`

### 2. 验证安装

**Windows 验证：**
```powershell
Start-Process "wspet://param=aG9tZSAtZW50cmFuY2UgT3BlbkNsYXc="
```

如果显示"未找到关联的应用程序"错误，说明：
- PDFelement 未安装
- 版本过旧（需要 12.1.14+）
- 安装后需要重启系统以注册 `wspet://` 协议

**Linux 验证：**
```bash
/opt/apps/PDFelement/PDFToolbox --version
```

### 3. 添加技能到 AI Agent

```bash
# 将此技能添加到您的 AI Agent 工作空间
npx skills add https://github.com/wondershare-boop/pdfelement-skill
```

---

## 快速开始

### 触发方式

在 OpenClaw 或 Claude Code 中，用自然语言描述需求，技能将自动激活：

- *"把这个 PDF 转换成 Word 文档"*
- *"对这些扫描件进行 OCR 识别"*
- *"压缩这个 PDF 文件"*
- *"给这些 PDF 添加水印"*
- *"合并这 3 个 PDF 文件"*
- *"从这个表单中提取数据"*

### 工作原理

#### Windows 平台

使用 `wspet://` 自定义协议启动 PDFToolbox：

```powershell
# 使用推荐的 PowerShell 脚本
.\scripts\launch_wspet.ps1 -Command convert -TargetFormat .docx -Files @("C:\Docs\input.pdf")

# 或手动构建命令
$params = "convert -t .docx -f <base64_files_xml> -wsclaw -autoexec -entrance OpenClaw"
$base64Param = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($params))
Start-Process "wspet://param=$base64Param"
```

**重要：** Windows 上所有命令都必须包含 `-wsclaw -autoexec -entrance OpenClaw` 参数。

#### Linux 平台

直接执行 PDFToolbox 命令行工具：

```bash
# 标准启动方式
cd /opt/apps/PDFelement && ./PDFToolbox convert -t ".docx" -entrance AllToolsPage

# 从桌面会话启动（推荐用于 AI Agent）
cd /opt/apps/PDFelement && DISPLAY=:1 XAUTHORITY=/run/user/1000/gdm/Xauthority DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus ./PDFToolbox convert -t ".docx" -f "$(python3 scripts/build_file_payload.py /path/to/input.pdf)" -entrance AllToolsPage
```

### 文件预加载

使用 `-f` 参数可以预加载 PDF 文件，打开工具箱时文件已经被加载：

**文件列表 XML 格式：**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Files>
  <File>
    <Path>/absolute/path/to/file.pdf</Path>
    <Password></Password>
  </File>
</Files>
```

**辅助脚本：**

Windows:
```powershell
.\scripts\launch_wspet.ps1 -Command convert -TargetFormat .docx -Files @("C:\Docs\input.pdf")
```

Linux:
```bash
python3 scripts/build_file_payload.py /absolute/path/to/input.pdf
```

---

## 常用操作示例

### PDF 转 Word

**Windows:**
```powershell
.\scripts\launch_wspet.ps1 -Command convert -TargetFormat .docx -Files @("C:\Docs\report.pdf")
```

**Linux:**
```bash
cd /opt/apps/PDFelement && ./PDFToolbox convert -t ".docx" -f "$(python3 scripts/build_file_payload.py ~/Documents/report.pdf)" -entrance AllToolsPage
```

### OCR 文字识别

**Windows:**
```powershell
$params = "ocr -f <base64_files_xml> -wsclaw -autoexec -entrance OpenClaw"
$base64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($params))
Start-Process "wspet://param=$base64"
```

**Linux:**
```bash
cd /opt/apps/PDFelement && ./PDFToolbox ocr -entrance AllToolsPage
```

### 压缩 PDF

**Windows:**
```powershell
$params = "optimize -f <base64_files_xml> -wsclaw -autoexec -entrance OpenClaw"
$base64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($params))
Start-Process "wspet://param=$base64"
```

**Linux:**
```bash
cd /opt/apps/PDFelement && ./PDFToolbox optimize -entrance AllToolsPage
```

### 合并 PDF

**Windows:**
```powershell
.\scripts\launch_wspet.ps1 -Command combine -Files @("C:\Docs\file1.pdf", "C:\Docs\file2.pdf")
```

**Linux:**
```bash
cd /opt/apps/PDFelement && ./PDFToolbox combine -entrance AllToolsPage
```

---

## 支持的转换格式

| 目标格式 | 文件扩展名 | 说明 |
|---|---|---|
| Word | `.docx` | Microsoft Word 文档 |
| Excel | `.xlsx` | Microsoft Excel 工作表 |
| PowerPoint | `.pptx` | Microsoft PowerPoint 演示文稿 |
| 图片 | `.jpg`, `.png` | JPEG 或 PNG 图片 |
| 文本 | `.txt` | 纯文本 |
| HTML | `.html` | 网页格式 |
| XML | `.xml` | XML 数据格式 |
| EPUB | `.epub` | 电子书格式 |
| OFD | `.ofd` | 中国电子文档标准格式 |

---

## 错误处理

### Windows 常见问题

| 错误信息 | 原因 | 解决方案 |
|---|---|---|
| "未找到关联的应用程序" | PDFelement 未安装或版本过旧 | 从 https://pdf.wondershare.com/ 下载并安装 12.1.14+ 版本，安装后重启系统 |
| GUI 未打开 | 不在桌面会话中运行 | 确保在用户登录的桌面会话中执行命令 |
| Python 不可用 | 缺少 Python 环境 | 使用 PowerShell 脚本 `launch_wspet.ps1` 替代 |
| 自动执行未触发 | 单实例窗口状态残留 | 先发送 `/nowexit` 重置，等待后再执行任务 |

### Linux 常见问题

| 错误信息 | 原因 | 解决方案 |
|---|---|---|
| 命令未找到 | PDFToolbox 不存在 | 检查 `/opt/apps/PDFelement/PDFToolbox` 是否存在并可执行 |
| 无法打开显示 | 缺少图形化环境 | 确保在桌面会话中运行，或设置正确的 `DISPLAY`、`XAUTHORITY` 和 `DBUS_SESSION_BUS_ADDRESS` |
| 找不到共享库 | 库路径未设置 | 从 `/opt/apps/PDFelement` 目录运行或设置 `LD_LIBRARY_PATH=/opt/apps/PDFelement` |

---

## 版权声明

MIT License

Copyright © 2026 Wondershare PDFelement AI Team（万兴PDF AI 团队）

特此免费授予任何获得本软件副本和相关文档文件（下称"软件"）的人不受限制地处置该软件的权利，包括不受限制地使用、复制、修改、合并、发布、分发、转授许可和/或出售该软件副本，以及再授权被配发了本软件的人如上的权利，须在下列条件下：

上述版权声明和本许可声明应包含在该软件的所有副本或实质成分中。

本软件是"如此"提供的，没有任何形式的明示或暗示的保证，包括但不限于对适销性、特定用途的适用性和不侵权的保证。在任何情况下，作者或版权持有人都不对任何索赔、损害或其他责任负责，无论这些追责来自合同、侵权或其它行为中，还是产生于、源于或有关于本软件以及本软件的使用或其它处置。

---

## 常见问题（FAQ）

**Q：使用 PDFelement 技能是否需要付费？**  
A：本技能开源且免费使用（MIT License），但需要安装 PDFelement 应用程序。PDFelement 软件本身可能需要许可证，请参考万兴PDF官网。

**Q：支持哪些操作系统？**  
A：Windows（需要 12.1.14+ 版本）和 Linux（Ubuntu）。macOS 支持正在开发中。

**Q：为什么必须使用 `wspet://` 协议？**  
A：这是 PDFelement 在 Windows 上的标准启动方式，直接执行 `PDFToolbox.exe` 已被废弃。`wspet://` 协议确保参数正确编码和传递。

**Q：处理的文件数据会上传到云端吗？**  
A：不会。所有 PDF 操作都在本地计算机上完成，无需网络连接（除非使用翻译功能）。

**Q：Linux 上为什么需要桌面环境？**  
A：PDFToolbox 使用图形化界面（GUI），需要 X11 或 Wayland 显示服务器。无头服务器或 SSH 会话无法直接运行。

**Q：如何反馈问题或建议新功能？**  
A：请在 GitHub 仓库提交 Issue，或发送邮件至 📧 **ws-business@wondershare.cn**。

**Q：为什么 Windows 上所有命令都需要 `-wsclaw -autoexec -entrance OpenClaw`？**  
A：这些参数用于标识来自 AI Agent 的调用，启用自动执行功能，并确保正确的界面入口。这适用于所有命令，不仅仅是转换操作。

---

*完整命令行 API 规范请参阅 [`skills/pdfelement-skill/references/api-reference.md`](skills/pdfelement-skill/references/api-reference.md)。*  
*命令模板参考请参阅 [`skills/pdfelement-skill/references/launch-templates.md`](skills/pdfelement-skill/references/launch-templates.md)。*
