# Noto Color Emoji Flags

A lightweight font containing only flag emojis from Google's Noto Color Emoji font, optimized for Windows compatibility.

## Overview

This project creates a subset of the Noto Color Emoji font that contains only flag emojis, significantly reducing file size while maintaining full emoji flag support. The resulting font is perfect for applications that only need flag emoji support without the overhead of the complete emoji font.

## Features

- **Lightweight**: Contains only flag emojis, dramatically smaller than the full Noto Color Emoji font
- **Windows Compatible**: Uses the Windows-compatible version of Noto Color Emoji
- **Complete Flag Support**: Includes all country and regional flag emojis
- **Cross-platform**: Build scripts available for both Windows (PowerShell) and Unix-like systems (Bash)
- **Automated Process**: Simple one-command build process

## Prerequisites

### Required Tools

- **HarfBuzz**: The `hb-subset` tool is required for font subsetting
  - **Windows**: Download from [HarfBuzz releases](https://github.com/harfbuzz/harfbuzz/releases)
  - **macOS**: `brew install harfbuzz`
  - **Ubuntu/Debian**: `sudo apt-get install harfbuzz-utils`
  - **Fedora/RHEL**: `sudo dnf install harfbuzz-devel`

- **Python**: Required for font name table updates
  - **fontTools**: `pip install fonttools`

- **Internet Connection**: For downloading the source font

## Quick Start

### Windows (PowerShell)
```powershell
.\build.ps1
```

### Linux/macOS (Bash)
```bash
./build.sh
```

## What It Does

1. **Downloads Source Font**: Fetches the latest Windows-compatible Noto Color Emoji font from Google's repository
2. **Creates Subset**: Uses HarfBuzz to extract only flag-related Unicode characters
3. **Updates Metadata**: Renames the font to "Noto Color Emoji Flags" for clear identification
4. **Generates Output**: Creates `NotoColorEmoji-flagsonly_WindowsCompatible.ttf` in the `fonts/` directory

## Output

The build process generates:
- `fonts/NotoColorEmoji-flagsonly_WindowsCompatible.ttf` - The final flag-only font file

## Included Flag Characters

The font includes:
- All country flags (🇺🇸, 🇬🇧, 🇯🇵, etc.)
- Regional indicator symbols (U+1F1E6-U+1F1FF)
- Supporting characters for proper flag rendering
- Zero-width joiner (U+200D) for compound flags

## File Structure

```
├── build.ps1                    # Windows PowerShell build script
├── build.sh                     # Unix/Linux bash build script
├── update_flag_name.py          # Python script to update font names
├── flags-only-unicodes.txt      # Unicode list for flag characters
└── fonts/                       # Output directory (created during build)
    └── NotoColorEmoji-flagsonly_WindowsCompatible.ttf
```

## Technical Details

- **Source Font**: Noto Color Emoji (Windows Compatible version)
- **Subsetting Tool**: HarfBuzz hb-subset
- **Font Format**: TrueType (.ttf)
- **Character Encoding**: Unicode
- **Platform Support**: Cross-platform with Windows optimization

## Use Cases

- **Web Applications**: Lightweight flag emoji support
- **Mobile Apps**: Reduced bundle size for flag-only emoji needs
- **Desktop Applications**: Custom flag picker interfaces
- **Documentation**: Technical documentation requiring only flag emojis
- **Windows Font Fallback**: Set Noto flags as primary choice with Segoe UI Emoji as fallback

## Advanced Use Case: Replacing Windows System Flag Emojis

### Overview
You can replace the flag characters in Windows' built-in `seguiemj.ttf` (Segoe UI Emoji) font to use Google's more detailed and frequently updated flag emojis instead of Microsoft's versions.

### ⚠️ Important Warnings
- **System File Modification**: This process modifies a Windows system font file
- **Admin Rights Required**: You need administrator privileges
- **Backup Essential**: Always backup the original font file before making changes
- **Windows Updates**: System updates may restore the original font
- **System Stability**: Improper font modification can cause display issues

### Prerequisites
- Completed build process (generated flag-only font)
- Administrator access to Windows
- Font editing software (recommended: FontForge or similar)
- **FontTools** with additional utilities: `pip install fonttools[all]`

### Step-by-Step Process

#### 1. Backup System Font
```powershell
# Run as Administrator
Copy-Item "C:\Windows\Fonts\seguiemj.ttf" "C:\Windows\Fonts\seguiemj.ttf.backup"
```

#### 2. Extract Current System Font
```powershell
# Copy to working directory
Copy-Item "C:\Windows\Fonts\seguiemj.ttf" ".\fonts\seguiemj_original.ttf"
```

#### 3. Merge Flag Characters
Create a merge script (`merge_flags.py`):

```python
from fontTools import ttLib
from fontTools.merge import Merger
import shutil

def merge_flag_fonts():
    # Load fonts
    system_font = ttLib.TTFont("fonts/seguiemj_original.ttf")
    flags_font = ttLib.TTFont("fonts/NotoColorEmoji-flagsonly_WindowsCompatible.ttf")

    # Create merger instance
    merger = Merger()

    # Merge flag characters from Noto into Segoe UI Emoji
    # This replaces existing flag glyphs with Noto versions
    merged_font = merger.merge([system_font, flags_font])

    # Save merged font
    merged_font.save("fonts/seguiemj_with_noto_flags.ttf")
    print("Merged font created: seguiemj_with_noto_flags.ttf")

if __name__ == "__main__":
    merge_flag_fonts()
```

#### 4. Replace System Font
```powershell
# Run as Administrator - Stop Windows Font Cache Service
Stop-Service FontCache -Force

# Replace the system font
Copy-Item ".\fonts\seguiemj_with_noto_flags.ttf" "C:\Windows\Fonts\seguiemj.ttf" -Force

# Restart Font Cache Service
Start-Service FontCache

# Clear font cache
Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\*" -Force -ErrorAction SilentlyContinue
```

#### 5. Verification
1. Open any application that displays emojis (Notepad, Browser, etc.)
2. Type flag emojis: 🇺🇸 🇬🇧 🇯🇵 🇩🇪 🇫🇷
3. Verify that the flags now display Google's Noto versions

### Restoration Process
If you need to restore the original font:

```powershell
# Run as Administrator
Stop-Service FontCache -Force
Copy-Item "C:\Windows\Fonts\seguiemj.ttf.backup" "C:\Windows\Fonts\seguiemj.ttf" -Force
Start-Service FontCache
```

### Alternative: Font Linking (Safer Method)
Instead of replacing the system font, you can use Windows font linking:

1. Install the flag font in Windows: Double-click the `.ttf` file and click "Install"
2. Create a registry entry to link flag characters to your custom font
3. This method is safer but more complex to implement

### Advanced Use Case: Windows Font Priority Setup

### Overview
Configure Windows to prioritize the Noto Color Emoji Flags font for flag characters while falling back to the system's Segoe UI Emoji font for other emojis. This approach provides the best flag rendering without modifying system files.

### Benefits
- **Non-invasive**: No system file modification required
- **Safe**: Preserves original Windows fonts
- **Selective**: Only affects flag emoji rendering
- **Reversible**: Easy to undo changes
- **Update-proof**: Survives Windows updates

### Method 1: Font Linking via Registry (System-wide)

#### Prerequisites
- Administrator privileges
- Completed build process (flag font installed)

#### Step 1: Install the Flag Font
```powershell
# Install font for all users (requires admin)
Copy-Item ".\fonts\NotoColorEmoji-flagsonly_WindowsCompatible.ttf" "$env:SystemRoot\Fonts\"

# Register in registry
$fontName = "Noto Color Emoji Flags (TrueType)"
$fontFile = "NotoColorEmoji-flagsonly_WindowsCompatible.ttf"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Name $fontName -Value $fontFile
```

#### Step 2: Configure Font Linking
```powershell
# Create font linking registry entries
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink"

# Set Noto flags as primary for emoji characters, Segoe UI Emoji as fallback
$linkValue = @(
    "NotoColorEmoji-flagsonly_WindowsCompatible.ttf,Noto Color Emoji Flags",
    "seguiemj.ttf,Segoe UI Emoji"
)

New-ItemProperty -Path $regPath -Name "Segoe UI Emoji" -Value $linkValue -PropertyType MultiString -Force
```

#### Step 3: Restart Font Services
```powershell
# Restart Windows font cache
Stop-Service FontCache -Force
Start-Service FontCache

# Clear font cache
Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\*" -Force -ErrorAction SilentlyContinue
```

### Method 2: CSS Font Stack (Web Applications)

For web applications, use CSS font-family prioritization:

```css
/* Prioritize Noto flags, fallback to system emoji */
.emoji {
    font-family:
        "Noto Color Emoji Flags",
        "Segoe UI Emoji",
        "Apple Color Emoji",
        "Noto Color Emoji",
        sans-serif;
}

/* Alternative: specific to flag emojis */
.flag-emoji {
    font-family: "Noto Color Emoji Flags", "Segoe UI Emoji";
}
```

### Method 3: Application-Level Configuration

#### For Electron Apps
```javascript
// In main process
app.on('ready', () => {
    // Set font preferences
    systemPreferences.setUserDefault('NSFontFamilyClassName', 'string', 'Noto Color Emoji Flags');
});
```

#### For Desktop Applications
```csharp
// C# WPF example
public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();

        // Set font fallback
        var fontFamily = new FontFamily("Noto Color Emoji Flags, Segoe UI Emoji");
        this.FontFamily = fontFamily;
    }
}
```

### Verification

#### Test Font Priority
1. Open Notepad or any text editor
2. Type flag emojis: 🇺🇸 🇬🇧 🇯🇵 🇩🇪 🇫🇷
3. Type other emojis: 😀 😂 🎉 ❤️ 👍
4. Verify that:
   - Flags display using Noto style (more detailed)
   - Other emojis display using Segoe UI style

#### Browser Test
Create a test HTML file:
```html
<!DOCTYPE html>
<html>
<head>
    <style>
        body {
            font-family: "Noto Color Emoji Flags", "Segoe UI Emoji";
            font-size: 24px;
        }
    </style>
</head>
<body>
    <p>Flags: 🇺🇸 🇬🇧 🇯🇵 🇩🇪 🇫🇷 🇨🇳 🇮🇳</p>
    <p>Other: 😀 😂 🎉 ❤️ 👍 🐶 🌟</p>
</body>
</html>
```

### Removing Font Priority

#### Undo Registry Changes
```powershell
# Remove font linking
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink" -Name "Segoe UI Emoji"

# Restart font services
Stop-Service FontCache -Force
Start-Service FontCache
```

#### Uninstall Flag Font
```powershell
# Remove font file and registry entry
Remove-Item "$env:SystemRoot\Fonts\NotoColorEmoji-flagsonly_WindowsCompatible.ttf"
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "Noto Color Emoji Flags (TrueType)"
```

### Troubleshooting Font Priority

- **Changes not visible**: Clear browser cache and restart applications
- **Registry access denied**: Ensure running as administrator
- **Font conflicts**: Check for duplicate font installations
- **Performance issues**: Monitor system performance with large font stacks

### Notes

- Font linking affects system-wide emoji rendering
- Some applications may override system font settings
- Modern browsers handle font fallback automatically
- Mobile apps may require platform-specific implementations

## Troubleshooting
- **Font doesn't load**: Ensure font cache is cleared and services restarted
- **Garbled text**: Restore backup and check font integrity
- **Windows updates**: May need to repeat process after major updates
- **Performance issues**: Large merged fonts may impact system performance

### Notes
- This modification affects all applications system-wide
- Some applications may cache fonts and require restart
- Modern Windows versions have additional protection mechanisms
- Consider testing on a virtual machine first

### Common Issues

**"hb-subset tool not found"**
- Ensure HarfBuzz is installed and added to your system PATH

**"Failed to download font file"**
- Check your internet connection
- Verify the GitHub URL is accessible

**"Python script execution failed"**
- Ensure Python is installed and in PATH
- Install fontTools: `pip install fonttools`

## Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

## License

This project uses fonts from Google's Noto project. Please refer to the [Noto repository](https://github.com/googlefonts/noto-emoji) for licensing information regarding the font files.

The build scripts and tools in this repository are provided as-is for educational and practical use.

## Acknowledgments

- Google Fonts team for the excellent Noto Color Emoji font
- HarfBuzz project for the powerful font subsetting tools
- fontTools library for font manipulation capabilities

---

**Note**: This project does not distribute the font files directly. The build process downloads the official font from Google's repository and creates the subset locally.