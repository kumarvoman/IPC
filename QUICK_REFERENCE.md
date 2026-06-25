# IPC Examples - Quick Reference

## Platform-Specific Compilation

### Windows (Batch)
```cmd
build_all.bat
```

### Windows (PowerShell)
```powershell
powershell -ExecutionPolicy Bypass -File build_all.ps1
```

### Unix/Linux/macOS
```bash
./build_all.sh
```

---

## File Index

### 01 - Anonymous Pipe
- **Type**: Parent-child one-way stream
- **Files**: `pipe_example.cpp` (combined demo)
- **Key API**: `pipe()` / `CreatePipe()`, `fork()` / N/A, `read()` / `ReadFile()`, `write()` / `WriteFile()`
- **Platforms**: ✅ Windows, Unix, Linux, macOS
- **Compile**:
  - **Unix**: `g++ -o pipe_example pipe_example.cpp`
  - **Windows**: `g++ -o pipe_example.exe pipe_example.cpp`
- **Run**: `./pipe_example` (or `pipe_example.exe`)

### 02 - Named Pipe (FIFO)
- **Type**: Local unrelated processes, one-way stream
- **Files**: `fifo_reader.cpp`, `fifo_writer.cpp`
- **Key API**: `mkfifo()` / `CreateNamedPipeA()`, `open()` / `CreateFileA()`, `read()` / `ReadFile()`
- **Platforms**: ✅ Windows, Unix, Linux, macOS
- **Compile**:
  - **Unix**: `g++ -o fifo_reader fifo_reader.cpp && g++ -o fifo_writer fifo_writer.cpp`
  - **Windows**: `g++ -o fifo_reader.exe fifo_reader.cpp && g++ -o fifo_writer.exe fifo_writer.cpp`
- **Run**: Terminal 1: `./fifo_reader`, Terminal 2: `./fifo_writer`

### 03 - POSIX Message Queue
- **Type**: Discrete messages with priority
- **Files**: `mq_receiver.cpp`, `mq_sender.cpp`
- **Key API**: `mq_open()`, `mq_send()`, `mq_receive()`
- **Platforms**: ⚠️ Linux only (not supported on macOS/Windows)
- **Compile**: `g++ -o mq_receiver mq_receiver.cpp -lrt`
- **Note**: Use Linux for this example; for cross-platform, use Message Queues (POSIX) alternative
- **Run**: Terminal 1: `./mq_receiver`, Terminal 2: `./mq_sender`

### 04 - Shared Memory
- **Type**: Direct memory segment mapped by multiple processes
- **Files**: `shm_reader.cpp`, `shm_writer.cpp`
- **Key API**: `shmget()` / `CreateFileMappingA()`, `shmat()` / `MapViewOfFile()`
- **Platforms**: ✅ Windows, Unix, Linux, macOS
- **Compile**:
  - **Unix**: `g++ -o shm_reader shm_reader.cpp && g++ -o shm_writer shm_writer.cpp`
  - **Windows**: `g++ -o shm_reader.exe shm_reader.cpp && g++ -o shm_writer.exe shm_writer.cpp`
- **Run**: Terminal 1: `./shm_reader`, Terminal 2: `./shm_writer`
- **Note**: Fastest but requires synchronization (semaphores) to prevent race conditions

### 05 - Semaphore Synchronization
- **Type**: Synchronization primitives protecting shared memory
- **Files**: `sem_reader.cpp`, `sem_writer.cpp`
- **Key API**: `sem_open()` / `CreateSemaphoreA()`, `sem_wait()` / `WaitForSingleObject()`
- **Platforms**: ✅ Windows, Unix, Linux, macOS
- **Compile**:
  - **Unix**: `g++ -o sem_reader sem_reader.cpp && g++ -o sem_writer sem_writer.cpp`
  - **Windows**: `g++ -o sem_reader.exe sem_reader.cpp && g++ -o sem_writer.exe sem_writer.cpp`
- **Run**: Terminal 1: `./sem_reader`, Terminal 2: `./sem_writer`
- **Note**: Usually paired with shared memory for coordination

### 06 - Signals / Events
- **Type**: Asynchronous event notifications
- **Files**: `signal_example.cpp` (combined demo)
- **Key API**: `signal()` / `SetConsoleCtrlHandler()`, `kill()` / `SetEvent()`
- **Platforms**: ✅ Windows (events), Unix/Linux (signals)
- **Compile**:
  - **Unix**: `g++ -o signal_example signal_example.cpp`
  - **Windows**: `g++ -o signal_example.exe signal_example.cpp`
- **Run**: `./signal_example`
- **Note**: Windows uses Windows Events API; Unix uses POSIX signals

### 07 - Unix Domain Socket
- **Type**: Local client-server (Unix) / TCP fallback (Windows)
- **Files**: `uds_server.cpp`, `uds_client.cpp`
- **Key API**: `socket(AF_UNIX, ...)` / `socket(AF_INET, ...)` (port 6666), `bind()`, `listen()`, `accept()`
- **Platforms**: ✅ Unix/Linux (AF_UNIX), Windows (TCP localhost fallback)
- **Compile**:
  - **Unix**: `g++ -o uds_server uds_server.cpp && g++ -o uds_client uds_client.cpp`
  - **Windows**: `g++ -o uds_server.exe uds_server.cpp -lws2_32 && g++ -o uds_client.exe uds_client.cpp -lws2_32`
- **Run**: Terminal 1: `./uds_server`, Terminal 2: `./uds_client`
- **Note**: Windows uses TCP on 127.0.0.1:6666 instead of Unix sockets

### 08 - TCP Socket
- **Type**: IP-based socket (local or remote)
- **Files**: `tcp_server.cpp`, `tcp_client.cpp`
- **Key API**: `socket()`, `bind()`, `listen()`, `accept()`, `connect()` (same on all platforms)
- **Platforms**: ✅ Windows, Unix, Linux, macOS
- **Compile**:
  - **Unix**: `g++ -o tcp_server tcp_server.cpp && g++ -o tcp_client tcp_client.cpp`
  - **Windows**: `g++ -o tcp_server.exe tcp_server.cpp -lws2_32 && g++ -o tcp_client.exe tcp_client.cpp -lws2_32`
- **Run**: Terminal 1: `./tcp_server`, Terminal 2: `./tcp_client`
- **Advantage**: Works across networks, standard API

### 09 - Memory-Mapped File
- **Type**: File mapped to shared memory, persistent
- **Files**: `mmap_reader.cpp`, `mmap_writer.cpp`
- **Key API**: `mmap()` / `CreateFileMappingA()`, `munmap()` / `UnmapViewOfFile()`
- **Platforms**: ✅ Windows, Unix, Linux, macOS
- **Compile**:
  - **Unix**: `g++ -o mmap_reader mmap_reader.cpp && g++ -o mmap_writer mmap_writer.cpp`
  - **Windows**: `g++ -o mmap_reader.exe mmap_reader.cpp && g++ -o mmap_writer.exe mmap_writer.cpp`
- **Run**: Terminal 1: `./mmap_reader`, Terminal 2: `./mmap_writer`
- **Advantage**: Fast + persistent to disk

### 10 - RPC over TCP
- **Type**: Typed method calls serialized as JSON
- **Files**: `rpc_server.cpp`, `rpc_client.cpp`
- **Key API**: `socket()` (TCP), JSON serialization (nlohmann/json)
- **Dependency**: `nlohmann/json` header
  - **macOS**: `brew install nlohmann-json`
  - **Windows/Linux**: Download from [nlohmann/json](https://github.com/nlohmann/json/releases)
  - **Place**: `10_rpc_over_tcp/nlohmann/json.hpp`
- **Platforms**: ✅ Windows, Unix, Linux, macOS
- **Compile**:
  - **Unix**: `g++ -std=c++17 -o rpc_server rpc_server.cpp && g++ -std=c++17 -o rpc_client rpc_client.cpp`
  - **Windows**: `g++ -std=c++17 -o rpc_server.exe rpc_server.cpp -lws2_32 && g++ -std=c++17 -o rpc_client.exe rpc_client.cpp -lws2_32`
- **Run**: Terminal 1: `./rpc_server`, Terminal 2: `./rpc_client`
- **Advantage**: Type-safe APIs, language-agnostic

---

## Build Scripts

### All-In-One Build

#### Windows (Batch)
```cmd
cd ipc_examples
build_all.bat
```

#### Windows (PowerShell)
```powershell
cd ipc_examples
powershell -ExecutionPolicy Bypass -File build_all.ps1
```

#### Unix/Linux/macOS
```bash
cd ipc_examples
chmod +x build_all.sh  # First time only
./build_all.sh
```

---

## Platform Support Matrix

| # | Mechanism | Windows | Linux | macOS | Notes |
|---|-----------|---------|-------|-------|-------|
| 01 | Anonymous Pipe | ✅ | ✅ | ✅ | Full support all platforms |
| 02 | Named Pipe | ✅ | ✅ | ✅ | CreateNamedPipeA on Windows, mkfifo on Unix |
| 03 | POSIX MQ | ❌ | ✅ | ⚠️ | Linux only; limited macOS support |
| 04 | Shared Memory | ✅ | ✅ | ✅ | Full support all platforms |
| 05 | Semaphore | ✅ | ✅ | ✅ | Full support all platforms |
| 06 | Signals/Events | ✅ | ✅ | ✅ | Events on Windows, Signals on Unix |
| 07 | Unix Domain Socket | ✅* | ✅ | ✅ | TCP fallback on Windows (port 6666) |
| 08 | TCP Socket | ✅ | ✅ | ✅ | Full support all platforms |
| 09 | Memory-Mapped File | ✅ | ✅ | ✅ | Full support all platforms |
| 10 | RPC over TCP | ✅ | ✅ | ✅ | Requires nlohmann/json (external) |

*Windows uses TCP localhost fallback for Unix Domain Socket

---

## Common Compilation Errors & Solutions

### "g++ command not found"
- **Windows**: Install MinGW-w64 and add to PATH
- **macOS**: Run `xcode-select --install`
- **Linux**: Run `sudo apt-get install build-essential` (Debian) or equivalent

### "-lws2_32" error on Unix
- **Solution**: Only needed on Windows; Unix examples don't use this flag
- Remove `-lws2_32` when compiling on Unix/Linux/macOS

### "nlohmann/json.hpp not found"
- **Solution**: Download from https://github.com/nlohmann/json/releases
- Extract and place `json.hpp` in `10_rpc_over_tcp/nlohmann/json.hpp`

### Socket already in use (Address already in use)
- **Solution**: Wait 30 seconds for socket to close, or:
- Kill previous server process: `ps aux | grep tcp_server`, then `kill <PID>`

### Permission denied on Unix scripts
- **Solution**: `chmod +x build_all.sh` then retry

---

## Quick Testing

### Test Anonymous Pipe (quickest)
```bash
cd 01_anonymous_pipe
g++ -o test test_example.cpp
./test
```

### Test Shared Memory + Semaphore (real-world scenario)
```bash
# Terminal 1
cd 04_shared_memory
g++ -o shm_writer shm_writer.cpp
./shm_writer

# Terminal 2 (while writer is running)
cd 04_shared_memory
g++ -o shm_reader shm_reader.cpp
./shm_reader
```

### Test Network Communication
```bash
# Terminal 1
cd 08_tcp_socket
g++ -o tcp_server tcp_server.cpp -lws2_32  # add -lws2_32 only on Windows
./tcp_server

# Terminal 2
cd 08_tcp_socket
g++ -o tcp_client tcp_client.cpp -lws2_32  # add -lws2_32 only on Windows
./tcp_client
```

---

## References

- [Windows IPC Docs](https://docs.microsoft.com/en-us/windows/win32/ipc/inter-process-communications)
- [POSIX IPC Man Pages](https://man7.org/linux/man-pages/man7/pthreads.7.html)
- [Beej's IPC Guide](https://beej.us/guide/bgipc/)
- [nlohmann/json](https://github.com/nlohmann/json)


# Shared Memory
cd 04_shared_memory && g++ -o shm_reader shm_reader.cpp && g++ -o shm_writer shm_writer.cpp

# Signals
cd 06_signals && g++ -o signal_example signal_example.cpp

# Unix Domain Socket
cd 07_unix_domain_socket && g++ -o uds_server uds_server.cpp && g++ -o uds_client uds_client.cpp

# TCP Socket
cd 08_tcp_socket && g++ -o tcp_server tcp_server.cpp && g++ -o tcp_client tcp_client.cpp

# Memory-Mapped File
cd 09_memory_mapped_file && g++ -o mmap_reader mmap_reader.cpp && g++ -o mmap_writer mmap_writer.cpp

# RPC (requires nlohmann-json)
cd 10_rpc_over_tcp && g++ -std=c++17 -o rpc_server rpc_server.cpp && g++ -std=c++17 -o rpc_client rpc_client.cpp
```

---

## Quick Execution Examples

### Single-Process Examples (run directly)
```bash
cd 01_anonymous_pipe && ./pipe_example
cd 06_signals && ./signal_example
```

### Multi-Process Examples (two terminals needed)
```bash
# Terminal 1: Server/Reader
cd 07_unix_domain_socket && ./uds_server

# Terminal 2: Client/Writer
cd 07_unix_domain_socket && ./uds_client
```

---

## Key API Reference

### File Operations
- `pipe()` - Create anonymous pipe
- `mkfifo()` - Create named pipe
- `open()` - Open file
- `close()` - Close file descriptor
- `read()`, `write()` - I/O operations

### Memory Operations
- `ftok()` - Generate shared memory key
- `shmget()` - Get/create shared memory segment
- `shmat()` - Attach shared memory
- `shmdt()` - Detach shared memory
- `mmap()` - Memory-map file
- `munmap()` - Unmap memory

### Socket Operations
- `socket()` - Create socket
- `bind()` - Bind to address
- `listen()` - Listen for connections
- `accept()` - Accept connection
- `connect()` - Initiate connection
- `read()`, `write()` - Send/receive data

### Process Operations
- `fork()` - Create child process
- `kill()` - Send signal to process
- `signal()`, `sigaction()` - Handle signals

### Synchronization
- `sem_open()` - Create/open semaphore
- `sem_wait()` - Wait on semaphore (blocks if 0)
- `sem_post()` - Post to semaphore (wakes waiter)

---

## Performance Tips

1. **Maximum speed**: Shared Memory + Semaphores (no kernel crossover)
2. **Fast local**: Unix Domain Sockets (low overhead)
3. **Network**: TCP Sockets (standard, well-optimized)
4. **Persistence**: Memory-Mapped Files or message queues
5. **Simplicity**: Pipes or Signals

---

## Troubleshooting

### macOS-Specific Issues
- Message queues not available (compile error on `#include <mqueue.h>`)
- Some semaphore operations behave differently
- Path limits: `/tmp/` socket paths may have length restrictions

### Linux-Specific Notes
- Full POSIX support for all mechanisms
- Message queues fully supported

### Common Errors
- `Address already in use`: Socket port is still in TIME_WAIT. Wait 30s or use `SO_REUSEADDR`.
- `Permission denied`: Check file/socket permissions or rerun with `sudo`.
- `File exists`: Clean up stale IPC files (pipes, sockets) in `/tmp/`.

