#!/bin/bash

#####################################################################
# MediaFire CLI Downloader
# A simple tool to download files from MediaFire via command line
# 
# Author: Protagoras
# License: MIT
# GitHub: https://github.com/protagoras-cs/mf-download
#####################################################################

VERSION="1.0.0"

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print colored output
print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_header() {
    echo -e "${BLUE}"
    echo "🔥 MediaFire CLI Downloader v${VERSION}"
    echo "=========================================${NC}"
}

# Check dependencies
check_dependencies() {
    local deps=("curl" "base64")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        print_error "Missing dependencies: ${missing[*]}"
        print_info "Please install missing dependencies and try again"
        exit 1
    fi
    
    # Check for download tools
    if ! command -v aria2c &> /dev/null && ! command -v wget &> /dev/null; then
        print_error "No download tool found. Please install either 'aria2c' or 'wget'"
        print_info "Recommended: sudo apt install aria2"
        exit 1
    fi
}

# Main download function
mf_download() {
    local url="$1"
    
    if [ -z "$url" ]; then
        print_error "No URL provided!"
        echo ""
        echo "Usage: $0 \"mediafire_url\""
        echo "Example: $0 \"https://www.mediafire.com/file/abc123/filename.zip/file\""
        return 1
    fi
    
    # Validate MediaFire URL
    if [[ ! "$url" =~ ^https?://.*mediafire\.com.* ]]; then
        print_error "Invalid MediaFire URL"
        print_info "Please provide a valid MediaFire link"
        return 1
    fi
    
    print_info "Analyzing MediaFire link..."
    print_info "URL: $url"
    echo ""
    
    # Fetch page and extract scrambled URL
    print_info "Fetching download page..."
    local page_content=$(curl -sL --max-time 30 "$url")
    
    if [ $? -ne 0 ] || [ -z "$page_content" ]; then
        print_error "Failed to fetch MediaFire page"
        print_info "Please check your internet connection and URL"
        return 1
    fi
    
    # Extract base64 encoded URL
    local encoded_url=$(echo "$page_content" | grep -o 'data-scrambled-url="[^"]*"' | cut -d'"' -f2 | head -1)
    
    if [ -z "$encoded_url" ]; then
        print_error "Could not find download URL"
        print_warning "This might happen if:"
        echo "  • The file has been deleted"
        echo "  • The link is invalid or expired"
        echo "  • MediaFire changed their page structure"
        echo "  • The file requires login/payment"
        return 1
    fi
    
    # Decode the scrambled URL
    print_info "Decoding download URL..."
    local real_url=$(echo "$encoded_url" | base64 -d 2>/dev/null)
    
    if [ -z "$real_url" ]; then
        print_error "Failed to decode download URL"
        return 1
    fi
    
    print_success "Real download URL found!"
    print_info "URL: ${real_url:0:80}..."
    echo ""
    
    # Extract filename from URL
    local filename=$(echo "$real_url" | sed 's/.*\///' | sed 's/+/ /g')
    print_info "Filename: $filename"
    echo ""
    
    # Start download
    print_info "Starting download..."
    
    if command -v aria2c &> /dev/null; then
        print_info "Using aria2c for faster download (6 parallel connections)"
        aria2c -x 6 -s 6 --summary-interval=5 --download-result=hide "$real_url"
    else
        print_info "Using wget for download"
        wget -c --progress=bar:force "$real_url"
    fi
    
    if [ $? -eq 0 ]; then
        echo ""
        print_success "Download completed successfully!"
        print_info "File saved as: $filename"
    else
        echo ""
        print_error "Download failed!"
        print_info "You can try downloading manually with:"
        echo "wget \"$real_url\""
        return 1
    fi
}

# Show help
show_help() {
    print_header
    echo ""
    echo "Usage: $0 [OPTIONS] \"mediafire_url\""
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -v, --version  Show version information"
    echo ""
    echo "Examples:"
    echo "  $0 \"https://www.mediafire.com/file/abc123/filename.zip/file\""
    echo "  $0 \"https://www.mediafire.com/download/xyz789\""
    echo ""
    echo "Dependencies:"
    echo "  Required: curl, base64, wget (or aria2c)"
    echo "  Optional: aria2c (for faster downloads)"
    echo ""
}

# Show version
show_version() {
    echo "MediaFire CLI Downloader v${VERSION}"
}

# Main execution
main() {
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--version)
            show_version
            exit 0
            ;;
        "")
            print_header
            print_error "No URL provided"
            echo ""
            show_help
            exit 1
            ;;
        *)
            print_header
            check_dependencies
            mf_download "$1"
            ;;
    esac
}

# If script is being sourced, just define the function
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
