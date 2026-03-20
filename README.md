# PDFelement AI Skill

> **Author:** PDFelement AI Team · **Organization:** Wondershare PDFelement  
> **Version:** 1.1.0 · **License:** MIT License © 2026 Wondershare PDFelement.

An AI skill for AI Agent (OpenClaw, Claude Code, etc.) that executes local PDF batch operations through the PDFelement toolbox.

---

## What This Skill Does

The `pdfelement-skill` lets you process PDF files in batch using the locally installed PDFelement application through natural language commands. It supports 20+ PDF operations including conversion, OCR, compression, translation, watermarking, security, splitting, merging, and more.

### Supported Operations

| Operation | Best For | Command |
|---|---|---|
| **Convert** | PDF to Word, Excel, PowerPoint, images, text, etc. | `convert` |
| **Data Extract** | Extract data from forms or tables | `dataExtract` |
| **Optimize** | Compress or reduce PDF file size | `optimize` |
| **OCR** | Recognize text in scanned PDFs | `ocr` |
| **Translate** | Translate PDF documents | `translate` |
| **Watermark** | Add watermarks | `watermark` |
| **Background** | Add backgrounds | `background` |
| **Header/Footer** | Add headers or footers | `headerFooter` |
| **Bates Number** | Add Bates numbering | `batesNumber` |
| **Security** | Set passwords or permissions | `security` |
| **Batch Print** | Batch print PDFs | `batchPrint` |
| **Delete Blank Pages** | Remove blank pages | `deleteBlankPages` |
| **Sign** | Add signatures | `sign` |
| **Split** | Split PDFs | `split` |
| **Combine** | Merge PDFs | `combine` |
| **Crop** | Crop pages | `crop` |
| **Create** | Create PDFs | `create` |

### What Problems It Solves

- **Local processing** — All PDF operations are performed locally without uploading files to the cloud, ensuring privacy and data security.
- **Batch automation** — Process multiple PDF files in batch through command-line interface, improving work efficiency.
- **AI natural language control** — Describe your needs in natural language; AI automatically selects the correct tool and parameters to execute tasks.
- **Professional PDF capabilities** — Supports advanced PDF processing features like OCR, translation, and data extraction.

---

## System Requirements

### Windows
- **PDFelement 12.1.14 or later** must be installed
- System must have the `wspet://` custom protocol registered
- Must run in a user desktop session

### Linux (Ubuntu)
- **PDFelement** must be installed in `/opt/apps/PDFelement`
- Requires graphical desktop environment (X11 or Wayland)
- Requires `DISPLAY` environment variable to be set

---

## Installation

### 1. Install PDFelement

**Download:** https://pdf.wondershare.com/

- Windows: Install PDFelement 12.1.14 or later
- Linux: Follow official instructions to install to `/opt/apps/PDFelement`

### 2. Verify Installation

**Windows verification:**
```powershell
Start-Process "wspet://param=aG9tZSAtZW50cmFuY2UgT3BlbkNsYXc="
```

If you see "No application is associated with the specified file" error, it means:
- PDFelement is not installed
- Version is too old (requires 12.1.14+)
- System restart needed after installation to register `wspet://` protocol

**Linux verification:**
```bash
/opt/apps/PDFelement/PDFToolbox --version
```

### 3. Add Skill to Your AI Agent

```bash
# Add this skill to your AI Agent workspace
npx skills add https://github.com/wondershare-boop/pe-skills
```

---

## Quick Start

### Trigger Phrases

The skill activates automatically when you say things like:

- *"Convert this PDF to Word"*
- *"Run OCR on these scanned documents"*
- *"Compress this PDF file"*
- *"Add watermark to these PDFs"*
- *"Merge these 3 PDF files"*
- *"Extract data from this form"*

### How It Works

#### Windows Platform

Use the `wspet://` custom protocol to launch PDFToolbox:

```powershell
# Using the recommended PowerShell script
.\scripts\launch_wspet.ps1 -Command convert -TargetFormat .docx -Files @("C:\Docs\input.pdf")

# Or build command manually
$params = "convert -t .docx -f <base64_files_xml> -wsclaw -autoexec -entrance OpenClaw"
$base64Param = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($params))
Start-Process "wspet://param=$base64Param"
```

**Important:** All commands on Windows must include `-wsclaw -autoexec -entrance OpenClaw` parameters.

#### Linux Platform

Execute PDFToolbox command-line tool directly:

```bash
# Standard launch
cd /opt/apps/PDFelement && ./PDFToolbox convert -t ".docx" -entrance AllToolsPage

# Launch from desktop session (recommended for AI Agent)
cd /opt/apps/PDFelement && DISPLAY=:1 XAUTHORITY=/run/user/1000/gdm/Xauthority DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus ./PDFToolbox convert -t ".docx" -f "$(python3 scripts/build_file_payload.py /path/to/input.pdf)" -entrance AllToolsPage
```

### File Pre-loading

Use the `-f` parameter to pre-load PDF files so they're already loaded when the toolbox opens:

**File list XML format:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Files>
  <File>
    <Path>/absolute/path/to/file.pdf</Path>
    <Password></Password>
  </File>
</Files>
```

**Helper scripts:**

Windows:
```powershell
.\scripts\launch_wspet.ps1 -Command convert -TargetFormat .docx -Files @("C:\Docs\input.pdf")
```

Linux:
```bash
python3 scripts/build_file_payload.py /absolute/path/to/input.pdf
```

---

## Common Operation Examples

### PDF to Word Conversion

**Windows:**
```powershell
.\scripts\launch_wspet.ps1 -Command convert -TargetFormat .docx -Files @("C:\Docs\report.pdf")
```

**Linux:**
```bash
cd /opt/apps/PDFelement && ./PDFToolbox convert -t ".docx" -f "$(python3 scripts/build_file_payload.py ~/Documents/report.pdf)" -entrance AllToolsPage
```

### OCR Text Recognition

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

### Compress PDF

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

### Merge PDFs

**Windows:**
```powershell
.\scripts\launch_wspet.ps1 -Command combine -Files @("C:\Docs\file1.pdf", "C:\Docs\file2.pdf")
```

**Linux:**
```bash
cd /opt/apps/PDFelement && ./PDFToolbox combine -entrance AllToolsPage
```

---

## Supported Conversion Formats

| Target Format | File Extension | Description |
|---|---|---|
| Word | `.docx` | Microsoft Word document |
| Excel | `.xlsx` | Microsoft Excel spreadsheet |
| PowerPoint | `.pptx` | Microsoft PowerPoint presentation |
| Images | `.jpg`, `.png` | JPEG or PNG images |
| Text | `.txt` | Plain text |
| HTML | `.html` | Web page format |
| XML | `.xml` | XML data format |
| EPUB | `.epub` | E-book format |
| OFD | `.ofd` | Chinese electronic document standard |

---

## Error Handling

### Windows Common Issues

| Error Message | Cause | Solution |
|---|---|---|
| "No application is associated with the specified file" | PDFelement not installed or version too old | Download and install 12.1.14+ from https://pdf.wondershare.com/, restart system after installation |
| GUI doesn't open | Not running in desktop session | Ensure command is executed in the user's logged-in desktop session |
| Python unavailable | Missing Python environment | Use PowerShell script `launch_wspet.ps1` instead |
| Auto-execution not triggered | Stale single-instance window state | Send `/nowexit` to reset first, wait, then execute task |

### Linux Common Issues

| Error Message | Cause | Solution |
|---|---|---|
| Command not found | PDFToolbox doesn't exist | Check if `/opt/apps/PDFelement/PDFToolbox` exists and is executable |
| Could not open display | Missing graphical environment | Ensure running in desktop session, or set correct `DISPLAY`, `XAUTHORITY`, and `DBUS_SESSION_BUS_ADDRESS` |
| Shared library not found | Library path not set | Run from `/opt/apps/PDFelement` directory or set `LD_LIBRARY_PATH=/opt/apps/PDFelement` |

---

## Copyright

MIT License

Copyright © 2026 Wondershare PDFelement AI Team

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---

## FAQ

**Q: Is the PDFelement skill free to use?**  
A: This skill is open source and free to use (MIT License), but requires PDFelement application to be installed. PDFelement software itself may require a license; please refer to the official Wondershare PDFelement website.

**Q: What operating systems are supported?**  
A: Windows (requires version 12.1.14+) and Linux (Ubuntu). macOS support is under development.

**Q: Why must I use the `wspet://` protocol?**  
A: This is the standard launch method for PDFelement on Windows. Direct execution of `PDFToolbox.exe` is deprecated. The `wspet://` protocol ensures parameters are correctly encoded and passed.

**Q: Will my file data be uploaded to the cloud?**  
A: No. All PDF operations are performed locally on your computer without requiring an internet connection (except when using translation features).

**Q: Why does Linux require a desktop environment?**  
A: PDFToolbox uses a graphical user interface (GUI) and requires an X11 or Wayland display server. Headless servers or SSH sessions cannot run it directly.

**Q: How do I report a bug or request a feature?**  
A: Please submit an Issue on the GitHub repository, or send an email to 📧 **ws-business@wondershare.cn**.

**Q: Why do all Windows commands need `-wsclaw -autoexec -entrance OpenClaw`?**  
A: These parameters identify calls from AI agents, enable auto-execution, and ensure the correct interface entry point. This applies to all commands, not just conversion operations.

---

*For full command-line API specifications, see [`skills/pdfelement-skill/references/api-reference.md`](skills/pdfelement-skill/references/api-reference.md).*  
*For command templates, see [`skills/pdfelement-skill/references/launch-templates.md`](skills/pdfelement-skill/references/launch-templates.md).*
