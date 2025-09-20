# 🔥 MediaFire CLI Downloader

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell Script](https://badges.frapsoft.com/bash/v1/bash.png?v=103)](https://github.com/ellerbrock/open-source-badges/)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20WSL-lightgrey)](https://github.com/yourusername/mediafire-cli-downloader)

A simple, lightweight command-line tool to download files from MediaFire without browser hassle. Just paste the link and download! 

## ✨ Features

- 🚀 **Fast Downloads**: Automatic parallel downloading with aria2c (6 connections)
- 🔓 **Smart URL Decoding**: Automatically decodes MediaFire's scrambled URLs
- 📱 **Cross-Platform**: Works on Linux, macOS, and Windows WSL
- 🛠 **Zero Dependencies**: Uses only standard Unix tools (curl, base64, wget/aria2c)
- 💡 **Simple Usage**: One command, one download
- 🔄 **Resume Support**: Automatically resumes interrupted downloads

## 🚀 Quick Start

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/mediafire-cli-downloader.git
cd mediafire-cli-downloader

# Make executable
chmod +x mf_download.sh

# Add to PATH (optional)
sudo cp mf_download.sh /usr/local/bin/mf_download
```

### Usage

```bash
# Basic usage
./mf_download.sh "https://www.mediafire.com/file/abc123/filename.zip/file"

# Or if added to PATH
mf_download "https://www.mediafire.com/file/abc123/filename.zip/file"
```

## 📋 Requirements

### Required
- `curl` - for web requests
- `base64` - for URL decoding (usually built-in)
- `wget` - for downloading (fallback)

### Optional (but recommended)
- `aria2c` - for faster parallel downloads
  ```bash
  # Ubuntu/Debian
  sudo apt install aria2
  
  # macOS
  brew install aria2
  
  # Arch Linux
  sudo pacman -S aria2
  ```

## 🔧 Advanced Usage

### Add to Shell Profile

For permanent access, add the function to your shell profile:

```bash
# Add to ~/.bashrc or ~/.zshrc
echo 'source /path/to/mediafire-cli-downloader/mf_download.sh' >> ~/.bashrc
source ~/.bashrc
```

### Custom Download Directory

```bash
# Download to specific directory
cd /path/to/downloads
mf_download "mediafire_url"
```

## 🛠 How It Works

1. **Fetches the MediaFire page** using curl
2. **Extracts the scrambled URL** from `data-scrambled-url` attribute
3. **Decodes the Base64 encoded URL** to get the real download link
4. **Downloads the file** using aria2c (preferred) or wget (fallback)

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. 🍴 Fork the repository
2. 🌟 Create a feature branch (`git checkout -b feature/amazing-feature`)
3. 📝 Commit your changes (`git commit -m 'Add amazing feature'`)
4. 🚀 Push to the branch (`git push origin feature/amazing-feature`)
5. 🎯 Open a Pull Request

### Development Setup

```bash
git clone https://github.com/yourusername/mediafire-cli-downloader.git
cd mediafire-cli-downloader

# Test the script
./mf_download.sh "test_mediafire_url"
```

## 📊 Compatibility

| Platform | Status | Notes |
|----------|--------|-------|
| Linux    | ✅ Tested | All major distributions |
| macOS    | ✅ Tested | Requires Homebrew for aria2 |
| Windows WSL | ✅ Tested | Ubuntu/Debian WSL recommended |
| Windows Native | ❌ Not supported | Use WSL instead |

## 🐛 Troubleshooting

### Common Issues

**"Command not found: aria2c"**
```bash
sudo apt install aria2  # Ubuntu/Debian
brew install aria2      # macOS
```

**"Download URL not found"**
- Ensure the MediaFire link is valid and accessible
- Check if the file still exists on MediaFire
- Try the link in a browser first

**"Permission denied"**
```bash
chmod +x mf_download.sh
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- MediaFire for their file hosting service
- The aria2 team for the excellent download manager
- All contributors who helped improve this tool

## ⭐ Support

If this tool saved you time, please consider:
- ⭐ Starring this repository
- 🐛 Reporting issues
- 🤝 Contributing improvements
- ☕ [Buy me a coffee](https://buymeacoffee.com/yourusername)

---

**Made with ❤️ for the command-line enthusiasts**
