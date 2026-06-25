# Windows Build Script for IPC Examples (PowerShell)
# Requires: PowerShell 5.0+, MinGW-w64 (g++.exe) or MSVC compiler
# Usage: powershell -ExecutionPolicy Bypass -File build_all.ps1
# Or: .\build_all.ps1 -ExecutionPolicy Bypass

param(
    [switch]$Verbose = $false
)

$ErrorActionPreference = "Continue"
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "`n============================================================" -ForegroundColor Cyan
Write-Host "Windows IPC Examples Build Script (PowerShell)" -ForegroundColor Cyan
Write-Host "============================================================`n" -ForegroundColor Cyan

# Check if compiler is available
$compiler = Get-Command g++ -ErrorAction SilentlyContinue
if (-not $compiler) {
    Write-Host "[ERROR] g++ compiler not found!" -ForegroundColor Red
    Write-Host "Please install MinGW-w64 from: https://www.mingw-w64.org/" -ForegroundColor Yellow
    exit 1
}

Write-Host "[INFO] Compiler found:" -ForegroundColor Green
g++ --version | Select-Object -First 1

$successCount = 0
$failCount = 0
$skipCount = 0

# Function to build and track results
function Build-Example {
    param(
        [string]$SourceFile,
        [string]$OutputName,
        [string]$Folder,
        [string]$ExtraFlags = ""
    )
    
    $exePath = Join-Path $scriptPath $Folder $OutputName
    
    Write-Host "`n[COMPILE] $SourceFile -> $OutputName" -ForegroundColor Yellow
    
    Push-Location (Join-Path $scriptPath $Folder)
    
    # Remove old executable
    if (Test-Path $exePath) { Remove-Item $exePath -Force }
    
    $compileCmd = "g++ -o $OutputName $SourceFile $ExtraFlags"
    if ($Verbose) { Write-Host "  Command: $compileCmd" -ForegroundColor Gray }
    
    Invoke-Expression $compileCmd 2>&1 | ForEach-Object {
        if ($_ -match "error|Error") {
            Write-Host "  ERROR: $_" -ForegroundColor Red
        } else {
            if ($Verbose) { Write-Host "  $_" -ForegroundColor Gray }
        }
    }
    
    if (Test-Path $exePath) {
        Write-Host "  [OK] $OutputName created" -ForegroundColor Green
        Pop-Location
        return $true
    } else {
        Write-Host "  [FAILED] $OutputName not created" -ForegroundColor Red
        Pop-Location
        return $false
    }
}

# 01_anonymous_pipe
if (Build-Example "pipe_example.cpp" "pipe_example.exe" "01_anonymous_pipe") {
    $successCount++
} else {
    $failCount++
}

# 02_named_pipe_fifo
if (Build-Example "fifo_reader.cpp" "fifo_reader.exe" "02_named_pipe_fifo") {
    $successCount++
} else {
    $failCount++
}

if (Build-Example "fifo_writer.cpp" "fifo_writer.exe" "02_named_pipe_fifo") {
    $successCount++
} else {
    $failCount++
}

# 03_posix_message_queue
Write-Host "`n[SKIP] 03_posix_message_queue (Linux only - requires sys/mqueue.h)" -ForegroundColor Yellow
$skipCount++

# 04_shared_memory
if (Build-Example "shm_reader.cpp" "shm_reader.exe" "04_shared_memory") {
    $successCount++
} else {
    $failCount++
}

if (Build-Example "shm_writer.cpp" "shm_writer.exe" "04_shared_memory") {
    $successCount++
} else {
    $failCount++
}

# 05_semaphore_sync
if (Build-Example "sem_reader.cpp" "sem_reader.exe" "05_semaphore_sync") {
    $successCount++
} else {
    $failCount++
}

if (Build-Example "sem_writer.cpp" "sem_writer.exe" "05_semaphore_sync") {
    $successCount++
} else {
    $failCount++
}

# 06_signals
if (Build-Example "signal_example.cpp" "signal_example.exe" "06_signals") {
    $successCount++
} else {
    $failCount++
}

# 07_unix_domain_socket (TCP fallback on Windows)
if (Build-Example "uds_server.cpp" "uds_server.exe" "07_unix_domain_socket" "-lws2_32") {
    $successCount++
} else {
    $failCount++
}

if (Build-Example "uds_client.cpp" "uds_client.exe" "07_unix_domain_socket" "-lws2_32") {
    $successCount++
} else {
    $failCount++
}

# 08_tcp_socket
if (Build-Example "tcp_server.cpp" "tcp_server.exe" "08_tcp_socket" "-lws2_32") {
    $successCount++
} else {
    $failCount++
}

if (Build-Example "tcp_client.cpp" "tcp_client.exe" "08_tcp_socket" "-lws2_32") {
    $successCount++
} else {
    $failCount++
}

# 09_memory_mapped_file
if (Build-Example "mmap_reader.cpp" "mmap_reader.exe" "09_memory_mapped_file") {
    $successCount++
} else {
    $failCount++
}

if (Build-Example "mmap_writer.cpp" "mmap_writer.exe" "09_memory_mapped_file") {
    $successCount++
} else {
    $failCount++
}

# 10_rpc_over_tcp
Write-Host "`n[CHECK] 10_rpc_over_tcp - Checking for nlohmann/json.hpp..." -ForegroundColor Yellow
$jsonPath = Join-Path $scriptPath "10_rpc_over_tcp" "nlohmann" "json.hpp"
$jsonParentPath = Join-Path $scriptPath "nlohmann" "json.hpp"

if (-not (Test-Path $jsonPath) -and -not (Test-Path $jsonParentPath)) {
    Write-Host "  [WARNING] nlohmann/json.hpp not found" -ForegroundColor Yellow
    Write-Host "  Download from: https://github.com/nlohmann/json/releases" -ForegroundColor Gray
    Write-Host "  Place json.hpp in: $(Join-Path $scriptPath '10_rpc_over_tcp\nlohmann\')" -ForegroundColor Gray
}

if (Build-Example "rpc_server.cpp" "rpc_server.exe" "10_rpc_over_tcp" "-std=c++17 -lws2_32") {
    $successCount++
} else {
    $failCount++
}

if (Build-Example "rpc_client.cpp" "rpc_client.exe" "10_rpc_over_tcp" "-std=c++17 -lws2_32") {
    $successCount++
} else {
    $failCount++
}

# Summary
Write-Host "`n============================================================" -ForegroundColor Cyan
Write-Host "Build Summary" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "[OK]     Successful builds: $successCount" -ForegroundColor Green
Write-Host "[FAILED] Failed builds:     $failCount" -ForegroundColor $(if ($failCount -gt 0) { "Red" } else { "Green" })
Write-Host "[SKIP]   Skipped builds:    $skipCount" -ForegroundColor Yellow
Write-Host "============================================================`n" -ForegroundColor Cyan

if ($failCount -eq 0) {
    Write-Host "All builds completed successfully!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "Some builds failed. Check errors above." -ForegroundColor Red
    exit 1
}
