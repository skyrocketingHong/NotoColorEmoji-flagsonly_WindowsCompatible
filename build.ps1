#!/usr/bin/env pwsh

# Check if hb-subset is available in PATH
try {
    $hbSubset = Get-Command hb-subset -ErrorAction Stop
    Write-Host "Found hb-subset: $($hbSubset.Source)" -ForegroundColor Green
} catch {
    Write-Error "Error: hb-subset tool not found. Please ensure it's installed and added to PATH environment variable"
    exit 1
}

# Create fonts directory if it doesn't exist
if (-not (Test-Path "fonts")) {
    New-Item -ItemType Directory -Path "fonts" -Force
    Write-Host "Created fonts directory" -ForegroundColor Yellow
}

# Download the NotoColorEmoji font with Windows compatibility
$fontUrl = "https://github.com/googlefonts/noto-emoji/raw/main/fonts/NotoColorEmoji_WindowsCompatible.ttf"
$fontPath = "fonts\NotoColorEmoji_WindowsCompatible.ttf"

Write-Host "Downloading font file..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $fontUrl -OutFile $fontPath -ErrorAction Stop
    Write-Host "Font file downloaded successfully: $fontPath" -ForegroundColor Green
} catch {
    Write-Error "Failed to download font file: $($_.Exception.Message)"
    exit 1
}

# Check if required files exist
if (-not (Test-Path "flags-only-unicodes.txt")) {
    Write-Error "Error: flags-only-unicodes.txt file not found"
    exit 1
}

# Generate the flags-only subset of NotoColorEmoji with Windows compatibility
Write-Host "Generating flags-only font subset..." -ForegroundColor Cyan
try {
    & hb-subset --unicodes-file=flags-only-unicodes.txt --output-file=fonts/NotoColorEmoji-flagsonly_WindowsCompatible.ttf $fontPath
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Flags-only font subset generated successfully: NotoColorEmoji-flagsonly_WindowsCompatible.ttf" -ForegroundColor Green
    } else {
        throw "hb-subset execution failed with exit code: $LASTEXITCODE"
    }
} catch {
    Write-Error "Failed to generate font subset: $($_.Exception.Message)"
    exit 1
}

# Check if Python script exists
if (-not (Test-Path "update_flag_name.py")) {
    Write-Error "Error: update_flag_name.py file not found"
    exit 1
}

# Update the flag names in the flags-only subset
Write-Host "Updating flag names..." -ForegroundColor Cyan
try {
    & python update_flag_name.py
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Flag names updated successfully" -ForegroundColor Green
    } else {
        throw "Python script execution failed with exit code: $LASTEXITCODE"
    }
} catch {
    Write-Error "Failed to update flag names: $($_.Exception.Message)"
    exit 1
}

Write-Host "All steps completed successfully!" -ForegroundColor Green