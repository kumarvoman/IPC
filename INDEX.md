# IPC Examples - Complete Index

> **Last Updated**: 2026-06-22 | **Location**: `/Users/Voman.Kumar/Desktop/Code/ipc_examples/`

## 📖 Documentation Files

| File | Purpose |
|------|---------|
| **README.md** | Main entry point—overview, comparison table, quick start |
| **PROJECT_SUMMARY.md** | This project's architecture and statistics |
| **QUICK_REFERENCE.md** | File-by-file guide, compilation recipes, API reference |
| **INDEX.md** | This file—complete directory index |

## 🗂️ IPC Mechanism Folders

### 01 - Anonymous Pipe
**What**: One-way stream between parent and child process  
**When**: Parent-child communication only  
**Speed**: Medium | **Complexity**: Low  
**Files**:
- `pipe_example.cpp` — Complete parent/child demo
- `README.md` — Detailed explanation
- `pipe_example` (executable)

**Run**: `./01_anonymous_pipe/pipe_example`

---

### 02 - Named Pipe (FIFO)
**What**: One-way stream between unrelated local processes  
**When**: Decoupled producer-consumer  
**Speed**: Medium | **Complexity**: Low  
**Files**:
- `fifo_reader.cpp` — Consumer process
- `fifo_writer.cpp` — Producer process
- `README.md` — Detailed explanation
- `fifo_reader`, `fifo_writer` (executables)

**Run**: 
- Terminal 1: `./02_named_pipe_fifo/fifo_reader`
- Terminal 2: `./02_named_pipe_fifo/fifo_writer`

---

### 03 - POSIX Message Queue
**What**: Discrete messages with priority support  
**When**: Asynchronous message passing with priority  
**Speed**: Medium | **Complexity**: Medium | **Platform**: Linux (limited on macOS)  
**Files**:
- `mq_receiver.cpp` — Message consumer
- `mq_sender.cpp` — Message producer
- `README.md` — Detailed explanation

**Note**: Compile with `-lrt` flag; unavailable on macOS  
**Run** (Linux only):
- Terminal 1: `./03_posix_message_queue/mq_receiver`
- Terminal 2: `./03_posix_message_queue/mq_sender`

---

### 04 - Shared Memory
**What**: Direct memory segment mapped by multiple processes  
**When**: Fastest local IPC for structured data  
**Speed**: ⚡⚡⚡ Fastest | **Complexity**: Medium | **Requires**: Synchronization!  
**Files**:
- `shm_reader.cpp` — Reader process (read-only attach)
- `shm_writer.cpp` — Writer process
- `README.md` — Detailed explanation
- `shm_reader`, `shm_writer` (executables)

**Run**:
- Terminal 1: `./04_shared_memory/shm_reader`
- Terminal 2: `./04_shared_memory/shm_writer`

**⚠️ Important**: Use semaphores to synchronize access!

---

### 05 - Semaphore Synchronization
**What**: Synchronization primitives protecting shared memory  
**When**: Coordinating access to shared resources  
**Speed**: N/A (sync only) | **Complexity**: Medium  
**Files**:
- `sem_reader.cpp` — Reader with semaphore coordination
- `sem_writer.cpp` — Writer with semaphore coordination
- `README.md` — Detailed explanation
- `sem_reader`, `sem_writer` (executables)

**Run**:
- Terminal 1: `./05_semaphore_sync/sem_reader`
- Terminal 2: `./05_semaphore_sync/sem_writer`

**Concept**: Binary semaphores (values 0/1) act like mutexes; readers/writers coordinate turns

---

### 06 - Signals
**What**: Lightweight asynchronous event notifications  
**When**: Simple "something happened" alerts, not bulk data  
**Speed**: ⚡⚡⚡ Fastest | **Complexity**: Low  
**Files**:
- `signal_example.cpp` — Parent sends signals to child
- `README.md` — Detailed explanation
- `signal_example` (executable)

**Run**: `./06_signals/signal_example`

**Note**: Uses `SIGUSR1`, `SIGUSR2` (user-defined signals)

---

### 07 - Unix Domain Socket
**What**: File-based socket for local client-server  
**When**: Fast local IPC, better than pipes, simpler than TCP  
**Speed**: ⚡⚡ Fast | **Complexity**: Medium  
**Files**:
- `uds_server.cpp` — Server listening on socket
- `uds_client.cpp` — Client connecting to socket
- `README.md` — Detailed explanation
- `uds_server`, `uds_client` (executables)

**Run**:
- Terminal 1: `./07_unix_domain_socket/uds_server`
- Terminal 2: `./07_unix_domain_socket/uds_client`

**Advantage**: No network overhead, filesystem-based addressing

---

### 08 - TCP Socket
**What**: IP-based sockets (local via 127.0.0.1 or remote)  
**When**: Works locally or across networks  
**Speed**: ⚡ Good | **Complexity**: Medium  
**Files**:
- `tcp_server.cpp` — Server listening on port 5555
- `tcp_client.cpp` — Client connecting to 127.0.0.1:5555
- `README.md` — Detailed explanation
- `tcp_server`, `tcp_client` (executables)

**Run**:
- Terminal 1: `./08_tcp_socket/tcp_server`
- Terminal 2: `./08_tcp_socket/tcp_client`

**Advantage**: Standard API, works across networks

---

### 09 - Memory-Mapped File
**What**: File mapped to shared memory with persistence  
**When**: Large data + persistence, or database-like patterns  
**Speed**: ⚡⚡⚡ Fastest | **Complexity**: Medium  
**Files**:
- `mmap_reader.cpp` — Reader process
- `mmap_writer.cpp` — Writer process
- `README.md` — Detailed explanation
- `mmap_reader`, `mmap_writer` (executables)

**Run**:
- Terminal 1: `./09_memory_mapped_file/mmap_reader`
- Terminal 2: `./09_memory_mapped_file/mmap_writer`

**Advantage**: Fast like shared memory + persists to disk

---

### 10 - RPC over TCP
**What**: Type-safe method calls serialized as JSON  
**When**: Structured APIs, language-agnostic communication  
**Speed**: Good | **Complexity**: High  
**Files**:
- `rpc_server.cpp` — RPC server (add, multiply, concat methods)
- `rpc_client.cpp` — RPC client making typed calls
- `README.md` — Detailed explanation
- Build output (pending: requires nlohmann-json)

**Dependencies**: `nlohmann/json` header library  
**Install**: `brew install nlohmann-json`  
**Compile**: `g++ -std=c++17 -o rpc_server rpc_server.cpp`

**Run**:
- Terminal 1: `./10_rpc_over_tcp/rpc_server`
- Terminal 2: `./10_rpc_over_tcp/rpc_client`

**Advantage**: Type-safe, works with any language using JSON-RPC format

---

## 🔧 Build Scripts

### `build_all.sh`
Master build script that compiles all examples:
- Automatically detects platform limitations
- Skips unavailable mechanisms (e.g., message queues on macOS)
- Shows colored status for each build
- Provides build commands for manual compilation

**Usage**:
```bash
cd /Users/Voman.Kumar/Desktop/Code/ipc_examples
./build_all.sh
```

---

## 📊 Quick Comparison

| Mechanism | Type | Speed | Data Type | Local Only | Sync Required | Best For |
|-----------|------|-------|-----------|-----------|---------------|----------|
| 1. Anonymous Pipe | Stream | Medium | Bytes | Yes | No | Parent→Child |
| 2. Named Pipe | Stream | Medium | Bytes | Yes | No | Producer-Consumer |
| 3. Message Queue | Messages | Medium | Discrete msgs | Yes | No | Priority queuing |
| 4. Shared Memory | Struct | ⚡⚡⚡ | Anything | Yes | **Yes** | Max performance |
| 5. Semaphores | Sync | N/A | N/A | Yes | — | Lock resources |
| 6. Signals | Events | ⚡⚡⚡ | None (info only) | Yes | No | Notifications |
| 7. Unix Socket | Stream | ⚡⚡ | Bytes/Msgs | Yes | No | Local client-srv |
| 8. TCP Socket | Stream | ⚡ | Bytes/Msgs | No | No | Network + local |
| 9. Mmap File | Struct | ⚡⚡⚡ | Anything | Yes | Maybe | Large + persist |
| 10. RPC/JSON | Typed API | ⚡ | Structured | No | No | Typed remote calls |

---

## 🚀 Getting Started

### Option A: Run Pre-Compiled Examples
```bash
# Single-process
cd /Users/Voman.Kumar/Desktop/Code/ipc_examples/01_anonymous_pipe
./pipe_example

# Multi-process (two terminals)
# Terminal 1:
cd /Users/Voman.Kumar/Desktop/Code/ipc_examples/07_unix_domain_socket
./uds_server

# Terminal 2:
cd /Users/Voman.Kumar/Desktop/Code/ipc_examples/07_unix_domain_socket
./uds_client
```

### Option B: Rebuild All
```bash
cd /Users/Voman.Kumar/Desktop/Code/ipc_examples
./build_all.sh
```

### Option C: Read Documentation First
- **Beginners**: Start with [01_anonymous_pipe/README.md](01_anonymous_pipe/README.md)
- **Quick ref**: Check [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
- **Learn all**: Read root [README.md](README.md)

---

## 🎓 Learning Recommendations

1. **Easiest**: Anonymous Pipe (01) → Signals (06)
2. **Practical**: Unix Domain Socket (07) → TCP Socket (08)
3. **Advanced**: Shared Memory (04) + Semaphores (05)
4. **Modern**: RPC over TCP (10) with JSON serialization

---

## 📋 Statistics

- **Total Folders**: 10 IPC mechanisms
- **C++ Source Files**: 18
- **Documentation Files**: 13
- **Executables**: 14 (on macOS; 16+ on Linux)
- **Total LOC**: ~1,200 lines of well-commented code
- **Total Size**: ~700 KB (including executables)

---

## ⚠️ Platform Compatibility

✅ = Fully supported  
⚠️ = Limited support  
❌ = Not available  

| Mechanism | macOS | Linux |
|-----------|-------|-------|
| Anonymous Pipe | ✅ | ✅ |
| Named Pipe (FIFO) | ✅ | ✅ |
| Message Queue | ❌ | ✅ |
| Shared Memory | ✅ | ✅ |
| Semaphores | ✅ | ✅ |
| Signals | ✅ | ✅ |
| Unix Domain Socket | ✅ | ✅ |
| TCP Socket | ✅ | ✅ |
| Memory-Mapped File | ✅ | ✅ |
| RPC (JSON) | ⚠️ | ✅ |

(JSON library needs manual install on macOS)

---

## 🔗 See Also

- **Root README**: [README.md](README.md)
- **Project Summary**: [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)
- **Quick Reference**: [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
- **Build Script**: [build_all.sh](build_all.sh)

---

**Last Updated**: 2026-06-22  
**Status**: ✅ Ready to compile and run
