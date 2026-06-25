@echo off
REM Windows Build Script for IPC Examples
REM Requires: MinGW-w64 (g++.exe) or MSVC compiler
REM Usage: build_all.bat

setlocal enabledelayedexpansion

echo.
echo ============================================================
echo Windows IPC Examples Build Script
echo ============================================================
echo.

REM Check if compiler is available
where g++ >nul 2>nul
if errorlevel 1 (
    echo [ERROR] g++ compiler not found. Please install MinGW-w64.
    echo Download from: https://www.mingw-w64.org/
    exit /b 1
)

echo [INFO] Compiler found: 
g++ --version | findstr /R "g++"

cd /d "%~dp0"

set "SUCCESS_COUNT=0"
set "FAIL_COUNT=0"

REM 01_anonymous_pipe
echo.
echo [BUILD] 01_anonymous_pipe
cd 01_anonymous_pipe
if exist pipe_example.exe del pipe_example.exe
g++ -o pipe_example.exe pipe_example.cpp
if errorlevel 1 (
    echo [FAILED] 01_anonymous_pipe
    set /a FAIL_COUNT+=1
) else (
    echo [SUCCESS] pipe_example.exe
    set /a SUCCESS_COUNT+=1
)
cd ..

REM 02_named_pipe_fifo
echo.
echo [BUILD] 02_named_pipe_fifo
cd 02_named_pipe_fifo
if exist fifo_reader.exe del fifo_reader.exe
if exist fifo_writer.exe del fifo_writer.exe
g++ -o fifo_reader.exe fifo_reader.cpp
if errorlevel 1 (
    echo [FAILED] fifo_reader
    set /a FAIL_COUNT+=1
) else (
    echo [SUCCESS] fifo_reader.exe
    set /a SUCCESS_COUNT+=1
)
g++ -o fifo_writer.exe fifo_writer.cpp
if errorlevel 1 (
    echo [FAILED] fifo_writer
    set /a FAIL_COUNT+=1
) else (
    echo [SUCCESS] fifo_writer.exe
    set /a SUCCESS_COUNT+=1
)
cd ..

REM 03_posix_message_queue
echo.
echo [SKIP] 03_posix_message_queue (Linux only - requires sys/mqueue.h)

REM 04_shared_memory
echo.
echo [BUILD] 04_shared_memory
cd 04_shared_memory
if exist shm_reader.exe del shm_reader.exe
if exist shm_writer.exe del shm_writer.exe
g++ -o shm_reader.exe shm_reader.cpp
if errorlevel 1 (
    echo [FAILED] shm_reader
    set /a FAIL_COUNT+=1
) else (
    echo [SUCCESS] shm_reader.exe
    set /a SUCCESS_COUNT+=1
)
g++ -o shm_writer.exe shm_writer.cpp
if errorlevel 1 (
    echo [FAILED] shm_writer
    set /a FAIL_COUNT+=1
) else (
    echo [SUCCESS] shm_writer.exe
    set /a SUCCESS_COUNT+=1
)
cd ..

REM 05_semaphore_sync
echo.
echo [BUILD] 05_semaphore_sync
cd 05_semaphore_sync
if exist sem_reader.exe del sem_reader.exe
if exist sem_writer.exe del sem_writer.exe
g++ -o sem_reader.exe sem_reader.cpp
if errorlevel 1 (
    echo [FAILED] sem_reader
    set /a FAIL_COUNT+=1
) else (
    echo [SUCCESS] sem_reader.exe
    set /a SUCCESS_COUNT+=1
)
g++ -o sem_writer.exe sem_writer.cpp
if errorlevel 1 (
    echo [FAILED] sem_writer
    set /a FAIL_COUNT+=1
) else (
    echo [SUCCESS] sem_writer.exe
    set /a SUCCESS_COUNT+=1
)
cd ..

REM 06_signals
echo.
echo [BUILD] 06_signals
cd 06_signals
if exist signal_example.exe del signal_example.exe
g++ -o signal_example.exe signal_example.cpp
if errorlevel 1 (
    echo [FAILED] signal_example
    set /a FAIL_COUNT+=1
) else (
    echo [SUCCESS] signal_example.exe
    set /a SUCCESS_COUNT+=1
)
cd ..

REM 07_unix_domain_socket
echo.
echo [BUILD] 07_unix_domain_socket
cd 07_unix_domain_socket
if exist uds_server.exe del uds_server.exe
if exist uds_client.exe del uds_client.exe
g++ -o uds_server.exe uds_server.cpp -lws2_32
if errorlevel 1 (
    echo [FAILED] uds_server
    set /a FAIL_COUNT+=1
) else (
    echo [SUCCESS] uds_server.exe (TCP fallback)
    set /a SUCCESS_COUNT+=1
)
g++ -o uds_client.exe uds_client.cpp -lws2_32
if errorlevel 1 (
    echo [FAILED] uds_client
    set /a FAIL_COUNT+=1
) else (
    echo [SUCCESS] uds_client.exe (TCP fallback)
    set /a SUCCESS_COUNT+=1
)
cd ..

REM 08_tcp_socket
echo.
echo [BUILD] 08_tcp_socket
cd 08_tcp_socket
if exist tcp_server.exe del tcp_server.exe
if exist tcp_client.exe del tcp_client.exe
g++ -o tcp_server.exe tcp_server.cpp -lws2_32
if errorlevel 1 (
    echo [FAILED] tcp_server
    set /a FAIL_COUNT+=1
) else (
    echo [SUCCESS] tcp_server.exe
    set /a SUCCESS_COUNT+=1
)
g++ -o tcp_client.exe tcp_client.cpp -lws2_32
if errorlevel 1 (
    echo [FAILED] tcp_client
    set /a FAIL_COUNT+=1
) else (
    echo [SUCCESS] tcp_client.exe
    set /a SUCCESS_COUNT+=1
)
cd ..

REM 09_memory_mapped_file
echo.
echo [BUILD] 09_memory_mapped_file
cd 09_memory_mapped_file
if exist mmap_reader.exe del mmap_reader.exe
if exist mmap_writer.exe del mmap_writer.exe
g++ -o mmap_reader.exe mmap_reader.cpp
if errorlevel 1 (
    echo [FAILED] mmap_reader
    set /a FAIL_COUNT+=1
) else (
    echo [SUCCESS] mmap_reader.exe
    set /a SUCCESS_COUNT+=1
)
g++ -o mmap_writer.exe mmap_writer.cpp
if errorlevel 1 (
    echo [FAILED] mmap_writer
    set /a FAIL_COUNT+=1
) else (
    echo [SUCCESS] mmap_writer.exe
    set /a SUCCESS_COUNT+=1
)
cd ..

REM 10_rpc_over_tcp
echo.
echo [BUILD] 10_rpc_over_tcp
cd 10_rpc_over_tcp
if exist rpc_server.exe del rpc_server.exe
if exist rpc_client.exe del rpc_client.exe

REM Check if nlohmann/json header is available
if not exist ".\nlohmann\json.hpp" (
    if not exist "..\nlohmann\json.hpp" (
        echo [WARNING] nlohmann/json.hpp not found locally
        echo [INFO] Download from: https://github.com/nlohmann/json/releases
        echo [INFO] Place json.hpp in: %CD%\nlohmann\ or parent directory
    )
)

g++ -std=c++17 -o rpc_server.exe rpc_server.cpp -lws2_32
if errorlevel 1 (
    echo [FAILED] rpc_server
    set /a FAIL_COUNT+=1
) else (
    echo [SUCCESS] rpc_server.exe
    set /a SUCCESS_COUNT+=1
)
g++ -std=c++17 -o rpc_client.exe rpc_client.cpp -lws2_32
if errorlevel 1 (
    echo [FAILED] rpc_client
    set /a FAIL_COUNT+=1
) else (
    echo [SUCCESS] rpc_client.exe
    set /a SUCCESS_COUNT+=1
)
cd ..

REM Summary
echo.
echo ============================================================
echo Build Summary
echo ============================================================
echo [OK] Successful builds:   !SUCCESS_COUNT!
echo [FAILED] Failed builds:   !FAIL_COUNT!
echo ============================================================
echo.

if %FAIL_COUNT% equ 0 (
    echo All builds completed successfully!
    exit /b 0
) else (
    echo Some builds failed. Check errors above.
    exit /b 1
)
