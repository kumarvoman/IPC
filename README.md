# IPC Examples - Inter-Process Communication Patterns in C++

A comprehensive collection of 10 different IPC mechanisms implemented in C++, with ready-to-compile examples and documentation. **Now with cross-platform Windows support!**

## Overview

| # | Mechanism | Platform | Speed | Data Type | Sync Required | Use Case |
|---|-----------|----------|-------|-----------|---------------|----------|
| 1 | **Anonymous Pipe** | Win/Unix | Medium | Stream | No | Parent-child only |
| 2 | **Named Pipe (FIFO)** | Win/Unix | Medium | Stream | No | Unrelated local processes |
| 3 | **POSIX Message Queue** | Linux only | Medium | Messages | No | Priority-based queuing |
| 4 | **Shared Memory** | Win/Unix | **Fastest** | Structured data | **Yes** | Large data, real-time |
| 5 | **Semaphores** | Win/Unix | N/A (sync only) | N/A | **Core sync** | Protect shared resources |
| 6 | **Signals/Events** | Win/Unix | **Fastest** | Events only | No | Lightweight notifications |
| 7 | **Unix Domain Socket** | Unix only* | Fast | Stream/msgs | No | Local client-server |
| 8 | **TCP Socket** | Win/Unix | Good | Stream | No | Remote + local |
| 9 | **Memory-Mapped File** | Win/Unix | **Fastest** | Structured data | Maybe | Large data + persistence |
| 10 | **RPC over TCP** | Win/Unix | Good | Structured API | No | Type-safe remote calls |

*Note: Unix Domain Socket (07) uses TCP on Windows as a local fallback

## Platform Support

| Platform | Status | Requirements |
|----------|--------|--------------|
| **Linux** | ✅ Full | g++/gcc, standard libraries |
| **macOS** | ✅ Full | g++ (via Xcode), Homebrew optional |
| **Windows** | ✅ Full | MinGW-w64 or MSVC |

## Folder Structure

```
ipc_examples/
├── 01_anonymous_pipe/           # Parent-child pipe communication (Windows/Unix)
├── 02_named_pipe_fifo/           # FIFO between unrelated processes (Windows/Unix)
├── 03_posix_message_queue/       # Message queue with priorities (Linux only)
├── 04_shared_memory/             # Shared memory segment (Windows/Unix)
├── 05_semaphore_sync/            # Semaphore-protected shared memory (Windows/Unix)
├── 06_signals/                   # Signal/Event-based IPC (Windows/Unix)
├── 07_unix_domain_socket/        # Local socket IPC, TCP fallback on Windows
├── 08_tcp_socket/                # TCP socket IPC (Windows/Unix/Remote)
├── 09_memory_mapped_file/        # File-based shared memory (Windows/Unix)
├── 10_rpc_over_tcp/              # JSON-RPC over TCP (Windows/Unix/Remote)
├── build_all.sh                  # Unix/Linux build script
├── build_all.bat                 # Windows batch build script
├── build_all.ps1                 # Windows PowerShell build script
└── README.md                     # This file
```

## Quick Start

### Unix/Linux/macOS
```bash
# Build all examples
./build_all.sh

# Or manually
cd 01_anonymous_pipe
g++ -o pipe_example pipe_example.cpp
./pipe_example
```

### Windows (Batch)
```cmd
REM Run batch build script
build_all.bat

REM Or manually
cd 01_anonymous_pipe
g++ -o pipe_example.exe pipe_example.cpp
pipe_example.exe
```

### Windows (PowerShell)
```powershell
# Run PowerShell build script
powershell -ExecutionPolicy Bypass -File build_all.ps1

# Or manually
cd 01_anonymous_pipe
g++ -o pipe_example.exe pipe_example.cpp
.\pipe_example.exe
```

## Compilation Instructions by Platform

### Anonymous Pipe (01)
```bash
# Unix/Linux/macOS
g++ -o pipe_example pipe_example.cpp

# Windows
g++ -o pipe_example.exe pipe_example.cpp
```

### TCP Socket (08) - Requires winsock2 on Windows
```bash
# Unix/Linux/macOS
g++ -o tcp_server tcp_server.cpp

# Windows
g++ -o tcp_server.exe tcp_server.cpp -lws2_32
```

### Unix Domain Socket (07)
```bash
# Unix/Linux/macOS
g++ -o uds_server uds_server.cpp

# Windows (uses TCP fallback on localhost:6666)
g++ -o uds_server.exe uds_server.cpp -lws2_32
```

### RPC over TCP (10) - Requires C++17
```bash
# Unix/Linux/macOS
g++ -std=c++17 -o rpc_server rpc_server.cpp

# Windows
g++ -std=c++17 -o rpc_server.exe rpc_server.cpp -lws2_32
```

## Dependencies

- **Standard**: Most examples use only POSIX/Windows APIs (no external deps).
  - Unix/Linux: glibc, POSIX headers
  - Windows: Windows SDK (included with MinGW-w64)
- **RPC example (10)**: Requires `nlohmann/json` header
  - macOS: `brew install nlohmann-json`
  - Windows/Linux: Download from [nlohmann/json releases](https://github.com/nlohmann/json/releases)
  - Place `json.hpp` in: `10_rpc_over_tcp/nlohmann/json.hpp`

## Setup Instructions

### Windows Setup

#### Option 1: MinGW-w64 (Recommended)
1. Download from [mingw-w64.org](https://www.mingw-w64.org/downloads/)
2. Install to `C:\mingw-w64`
3. Add to PATH: `C:\mingw-w64\bin`
4. Verify: `g++ --version`

#### Option 2: MSVC Toolchain
1. Install Visual Studio or Visual Studio Build Tools
2. Open Visual Studio Developer Command Prompt
3. `cd ipc_examples && build_all.bat`

### macOS Setup
```bash
# Install Xcode command-line tools
xcode-select --install

# Optional: Install Homebrew packages
brew install nlohmann-json  # For RPC example
```

### Linux Setup
```bash
# Debian/Ubuntu
sudo apt-get install build-essential

# Fedora/RHEL
sudo dnf install gcc-c++ make
```

## Quick Decision Guide

**Use case: Simple parent-child communication?**
→ **Anonymous Pipe** (01) ✅ All platforms

**Use case: Local process data exchange, fast?**
→ **Unix Domain Socket** (07) or **Shared Memory** (04) ✅ All platforms

**Use case: Local process with huge data, persistent?**
→ **Memory-Mapped File** (09) ✅ All platforms

**Use case: Remote communication?**
→ **TCP Socket** (08) or **RPC** (10) ✅ All platforms

**Use case: Just notify "something happened"?**
→ **Signals** (06) ✅ All platforms

**Use case: Producer-consumer with priority?**
→ **POSIX Message Queue** (03) ⚠️ Linux only

**Use case: Synchronizing access to shared data?**
→ **Semaphore** (05) + Shared Memory (04) ✅ All platforms

## Platform-Specific Notes

### Windows
- Uses **WinAPI** (windows.h, winsock2.h) for IPC
- Named pipes (02) use `CreateNamedPipeA()`
- Shared memory (04) uses `CreateFileMappingA()`
- Semaphores (05) use `CreateSemaphoreA()`
- Sockets (08, 10) require `-lws2_32` linker flag
- Unix Domain Socket (07) falls back to TCP on localhost:6666
- All examples compiled with `-o name.exe` suffix

### Unix/Linux/macOS
- Uses **POSIX APIs** (fcntl.h, sys/socket.h, etc.)
- Named pipes (02) use `mkfifo()`
- Shared memory (04) uses `shmget()`/`shmat()`
- Semaphores (05) use `sem_open()`/`sem_wait()`
- Sockets (08, 10) use standard Berkeley sockets
- Unix Domain Socket (07) uses `AF_UNIX`
- Message Queue (03) uses `mq_open()` (Linux only)

### Code Organization
All examples use **conditional compilation**:
```cpp
#ifdef _WIN32
    // Windows implementation
#else
    // Unix/Linux implementation
#endif
```

This allows a single source file to compile on both platforms!

## Performance Characteristics

| Mechanism | Throughput | Latency | Consistency | Use Case Priority |
|-----------|-----------|---------|-------------|-------------------|
| Shared Memory + Semaphore | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | Real-time, high-frequency |
| Memory-Mapped File | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | Persistence + speed |
| Unix Domain Socket | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | General local IPC |
| Signals | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐ | Event notifications |
| TCP Socket | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | Network + local |
| Named Pipe | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ | Stream IPC |
| Message Queue | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | Ordered delivery |

## Troubleshooting

**Q: "g++ command not found" on Windows**
A: Install MinGW-w64 and add to PATH, or use Visual Studio Developer Command Prompt

**Q: "Permission denied" on Unix**
A: Run `chmod +x build_all.sh` first

**Q: Socket bind failed**
A: Previous process may still hold the port. Wait 30 seconds or use `-lws2_32` flag

**Q: "nlohmann/json.hpp not found"**
A: Download from https://github.com/nlohmann/json/releases and place in `10_rpc_over_tcp/nlohmann/`

## References

- [POSIX IPC Manual Pages](https://man7.org/linux/man-pages/man7/pthreads.7.html)
- [Windows IPC Documentation](https://docs.microsoft.com/en-us/windows/win32/ipc/inter-process-communications)
- [Unix Network Programming](https://www.amazon.com/Unix-Network-Programming-Richard-Stevens/dp/0131411551)
- [Beej's Guide to Unix IPC](https://beej.us/guide/bgipc/)
- [nlohmann/json](https://github.com/nlohmann/json)

---

**All examples are self-contained, cross-platform, and designed to compile on Windows, macOS, and Linux.**

Each one demonstrates a different IPC pattern with minimal code to help you understand the mechanism and adapt it for your own use cases.

Last updated: Cross-platform support added (Windows, Unix, Linux)

