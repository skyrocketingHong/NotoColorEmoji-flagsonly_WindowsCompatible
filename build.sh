#!/usr/bin/env bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_error() {
    echo -e "${RED}Error: $1${NC}" >&2
}

print_success() {
    echo -e "${GREEN}$1${NC}"
}

print_info() {
    echo -e "${CYAN}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}$1${NC}"
}

# Check if hb-subset is available in PATH
print_info "Checking for hb-subset tool..."
if command -v hb-subset >/dev/null 2>&1; then
    HB_SUBSET_PATH=$(which hb-subset)
    print_success "Found hb-subset: $HB_SUBSET_PATH"
else
    print_error "hb-subset tool not found. Please ensure it's installed and added to PATH environment variable"
    exit 1
fi

# Create fonts directory if it doesn't exist
if [ ! -d "fonts" ]; then
    mkdir -p fonts
    print_warning "Created fonts directory"
fi

# Download the NotoColorEmoji font with Windows compatibility
FONT_URL="https://github.com/googlefonts/noto-emoji/raw/main/fonts/NotoColorEmoji_WindowsCompatible.ttf"
FONT_PATH="fonts/NotoColorEmoji_WindowsCompatible.ttf"

print_info "Downloading font file..."
if wget -P fonts "$FONT_URL" -O "$FONT_PATH"; then
    print_success "Font file downloaded successfully: $FONT_PATH"
else
    print_error "Failed to download font file"
    exit 1
fi

# Check if required files exist
if [ ! -f "flags-only-unicodes.txt" ]; then
    print_error "flags-only-unicodes.txt file not found"
    exit 1
fi

# Generate the flags-only subset of NotoColorEmoji with Windows compatibility
print_info "Generating flags-only font subset..."
if hb-subset --unicodes-file=flags-only-unicodes.txt --output-file=fonts/NotoColorEmoji-flagsonly_WindowsCompatible.ttf "$FONT_PATH"; then
    print_success "Flags-only font subset generated successfully: NotoColorEmoji-flagsonly_WindowsCompatible.ttf"
else
    print_error "Failed to generate font subset"
    exit 1
fi

# Check if Python script exists
if [ ! -f "update_flag_name.py" ]; then
    print_error "update_flag_name.py file not found"
    exit 1
fi

# Update the flag names in the flags-only subset
print_info "Updating flag names..."
if python update_flag_name.py; then
    print_success "Flag names updated successfully"
else
    print_error "Failed to update flag names"
    exit 1
fi

print_success "All steps completed successfully!"