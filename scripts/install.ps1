# Neovim Configuration Setup Script for Windows

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

Write-Host "=== Neovim Configuration Setup ===" -ForegroundColor Green

# 1. Install or check Scoop
Write-Host "`n1. Checking Scoop installation..." -ForegroundColor Yellow

if (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Host "Scoop is already installed" -ForegroundColor Green
} else {
    Write-Host "Scoop not found, installing..." -ForegroundColor Yellow

    # Set execution policy
    try {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Write-Host "Execution policy set successfully" -ForegroundColor Green
    } catch {
        Write-Host "Failed to set execution policy: $($_.Exception.Message)" -ForegroundColor Red
    }

    # Install Scoop
    try {
        Write-Host "Installing Scoop..." -ForegroundColor Yellow
        Invoke-RestMethod -Uri "https://github.com/ScoopInstaller/Install/raw/master/install.ps1" | Invoke-Expression
        Write-Host "Scoop installed successfully" -ForegroundColor Green
    } catch {
        Write-Host "Scoop installation failed: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# 2. Add required buckets
Write-Host "`n2. Adding Scoop buckets..." -ForegroundColor Yellow

$buckets = @("main", "extras", "versions")
foreach ($bucket in $buckets) {
    if (scoop bucket list | Select-String $bucket) {
        Write-Host "Bucket '$bucket' already exists" -ForegroundColor Green
    } else {
        try {
            scoop bucket add $bucket
            Write-Host "Bucket '$bucket' added successfully" -ForegroundColor Green
        } catch {
            Write-Host "Failed to add bucket '$bucket': $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

# 3. Install dependencies
Write-Host "`n3. Installing dependencies..." -ForegroundColor Yellow

$dependencies = @(
    "fd", "fzf", "gh", "git", "glow", "grep",
    "lazygit", "lilex-nf", "make", "neovim",
    "nodejs-lts", "ripgrep", "ruff", "starship",
    "television", "tree-sitter", "ugrep", "uv",
    "wakatime-cli", "yazi", "zig", "zoxide"
)

foreach ($dep in $dependencies) {
    if (scoop list | Select-String $dep) {
        Write-Host "$dep already installed" -ForegroundColor Green
    } else {
        try {
            Write-Host "Installing $dep..." -ForegroundColor Yellow
            scoop install $dep
            Write-Host "$dep installed successfully" -ForegroundColor Green
        } catch {
            Write-Host "Failed to install $dep: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

# 4. Configure npm registry
Write-Host "`n4. Configuring npm registry..." -ForegroundColor Yellow
try {
    npm config set registry https://registry.npmmirror.com
    Write-Host "npm registry configured successfully" -ForegroundColor Green
} catch {
    Write-Host "npm registry configuration failed: $($_.Exception.Message)" -ForegroundColor Red
}

# 5. Install Python packages
Write-Host "`n5. Installing Python packages..." -ForegroundColor Yellow
try {
    pip install pynvim pywin32
    Write-Host "Python packages installed successfully" -ForegroundColor Green
} catch {
    Write-Host "Python packages installation failed: $($_.Exception.Message)" -ForegroundColor Red
}

# 6. Clone Neovim configuration to fei.nvim directory
Write-Host "`n6. Setting up Neovim configuration..." -ForegroundColor Yellow

$feiNvimDir = "$env:USERPROFILE\AppData\Local\fei.nvim"

if (Test-Path $feiNvimDir) {
    Write-Host "fei.nvim directory already exists, backing up..." -ForegroundColor Yellow
    $backupDir = "$feiNvimDir.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Move-Item $feiNvimDir $backupDir
    Write-Host "Backup created at: $backupDir" -ForegroundColor Green
}

try {
    Write-Host "Cloning Neovim configuration to fei.nvim..." -ForegroundColor Yellow
    git clone https://github.com/konosubakonoakua/fei.nvim.git $feiNvimDir
    Write-Host "Neovim configuration cloned successfully to: $feiNvimDir" -ForegroundColor Green
} catch {
    Write-Host "Failed to clone Neovim configuration: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 7. Configure git user
Write-Host "`n7. Configuring git user..." -ForegroundColor Yellow
try {
    Set-Location $feiNvimDir
    git config --local user.name "konosubakonoakua"
    git config --local user.email "ailike_meow@qq.com"
    Write-Host "Git user configured successfully" -ForegroundColor Green
} catch {
    Write-Host "Git user configuration failed: $($_.Exception.Message)" -ForegroundColor Red
}

# 8. Create fvim function for NVIM_APPNAME
Write-Host "`n8. Creating fvim function..." -ForegroundColor Yellow

$fvimFunction = @"

# fvim function for fei.nvim configuration
function fvim {
    `$env:NVIM_APPNAME = "fei.nvim"
    nvim @args
}
"@

try {
    # Add to PowerShell profile
    if (!(Test-Path $PROFILE)) {
        New-Item -ItemType File -Path $PROFILE -Force | Out-Null
    }

    # Check if function already exists
    $currentProfile = Get-Content $PROFILE -ErrorAction SilentlyContinue
    if ($currentProfile -notmatch "function fvim") {
        Add-Content -Path $PROFILE -Value "`n$fvimFunction"
        Write-Host "fvim function added to PowerShell profile" -ForegroundColor Green
    } else {
        Write-Host "fvim function already exists in profile" -ForegroundColor Green
    }

    # Also create the function in current session
    Invoke-Expression $fvimFunction
    Write-Host "fvim function created in current session" -ForegroundColor Green

} catch {
    Write-Host "Failed to create fvim function: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== Setup Complete! ===" -ForegroundColor Green
Write-Host "Neovim configuration has been installed successfully!" -ForegroundColor Green
Write-Host "`nUsage:" -ForegroundColor Yellow
Write-Host "  fvim                    - Start Neovim with fei.nvim configuration" -ForegroundColor White
Write-Host "  nvim                    - Start Neovim with default configuration" -ForegroundColor White
Write-Host "`nConfiguration location:" -ForegroundColor Cyan
Write-Host "  Config dir: $feiNvimDir" -ForegroundColor Cyan
Write-Host "  Data dir: ~/AppData/Local/fei.nvim" -ForegroundColor Cyan

# Optional: Start Neovim with fei.nvim configuration
$startNeovim = Read-Host "`nDo you want to start Neovim with fei.nvim configuration now? (y/n)"
if ($startNeovim -eq 'y' -or $startNeovim -eq 'Y') {
    Write-Host "Starting Neovim with fei.nvim configuration..." -ForegroundColor Yellow
    fvim
}
