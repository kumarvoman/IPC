# Detailed Explanation of IPC Mechanisms

A comprehensive guide to all 10 Inter-Process Communication mechanisms with diagrams, examples, and use cases.

---

## Table of Contents
1. [Anonymous Pipe](#1-anonymous-pipe)
2. [Named Pipe (FIFO)](#2-named-pipe-fifo)
3. [POSIX Message Queue](#3-posix-message-queue)
4. [Shared Memory](#4-shared-memory)
5. [Semaphore Synchronization](#5-semaphore-synchronization)
6. [Signals/Events](#6-signalsevents)
7. [Unix Domain Socket](#7-unix-domain-socket)
8. [TCP Socket](#8-tcp-socket)
9. [Memory-Mapped File](#9-memory-mapped-file)
10. [RPC over TCP](#10-rpc-over-tcp)

---

## 1. Anonymous Pipe

### What is it?
An **anonymous pipe** is a one-way communication channel between two processes that have a parent-child relationship. It's the simplest form of IPC, typically used when a parent process creates a child process and wants to exchange data with it.

### How it Works

```mermaid
graph LR
    Parent["Parent Process"]
    Child["Child Process"]
    Pipe["Pipe Buffer<br/>(Kernel Memory)"]
    
    Parent -->|write| Pipe
    Pipe -->|read| Child
    
    style Pipe fill:#ff9999
    style Parent fill:#99ccff
    style Child fill:#99ff99
```

**Data Flow:**
- Parent writes data → Pipe buffer (kernel memory)
- Child reads data ← Pipe buffer
- **Unidirectional**: One-way communication only
- **In-Memory**: No disk involvement, fast
- **Blocking**: Reading from empty pipe blocks the process

### Key Characteristics

| Aspect | Detail |
|--------|--------|
| **Direction** | Unidirectional (one-way) |
| **Scope** | Parent-child only |
| **Capacity** | ~64KB on most systems |
| **Speed** | Medium (memory-based) |
| **Persistence** | Lost when process exits |
| **Synchronization** | Auto-blocking on empty/full |

### Code Example

```cpp
#include <unistd.h>
#include <iostream>

int main() {
    int pipefd[2];  // pipefd[0] = read end, pipefd[1] = write end
    
    if (pipe(pipefd) == -1) {
        perror("pipe");
        return 1;
    }
    
    pid_t pid = fork();
    
    if (pid == 0) {
        // Child process
        close(pipefd[1]);  // Close write end (not used)
        
        char buffer[256];
        ssize_t n = read(pipefd[0], buffer, sizeof(buffer));
        std::cout << "[CHILD] Received: " << buffer << std::endl;
        close(pipefd[0]);
        
    } else {
        // Parent process
        close(pipefd[0]);  // Close read end (not used)
        
        const char* msg = "Hello from parent!";
        write(pipefd[1], msg, strlen(msg));
        close(pipefd[1]);
    }
    
    return 0;
}
```

### When to Use
- ✅ Parent needs to send data to spawned child
- ✅ Simple producer-consumer pattern
- ✅ Shell command piping (`cat file.txt | grep pattern`)
- ❌ Not for multiple unrelated processes
- ❌ Not for bidirectional communication

### Advantages
- Very fast (memory-based)
- Automatic synchronization
- Simple API
- No external dependencies

### Disadvantages
- Parent-child only (no flexibility)
- Unidirectional
- Small capacity (~64KB)
- Data lost when process exits

---

## 2. Named Pipe (FIFO)

### What is it?
A **FIFO (First-In-First-Out)** or **named pipe** is a special file on disk that enables two unrelated processes to communicate. Unlike anonymous pipes, FIFOs are persistent and don't require a parent-child relationship.

### How it Works

```mermaid
graph TB
    Writer["Writer Process<br/>(Unrelated)"]
    FIFO["FIFO File<br/>/tmp/ipc_fifo<br/>(kernel buffer)"]
    Reader["Reader Process<br/>(Unrelated)"]
    
    Writer -->|write| FIFO
    FIFO -->|read| Reader
    
    Filesystem["File System"]
    FIFO -.-> Filesystem
    
    style FIFO fill:#ffcc99
    style Writer fill:#99ccff
    style Reader fill:#99ff99
    style Filesystem fill:#e6e6e6
```

**Data Flow:**
1. Writer process opens FIFO for writing
2. Reader process opens FIFO for reading
3. Writer writes data → FIFO buffer
4. Reader reads data ← FIFO buffer
5. Data flows in **order** (FIFO semantics)

### Key Characteristics

| Aspect | Detail |
|--------|--------|
| **Direction** | Unidirectional |
| **Scope** | Any processes (no relationship needed) |
| **Storage** | Disk file (persistent name) |
| **Capacity** | ~64KB (kernel buffer) |
| **Speed** | Medium (faster than file I/O) |
| **Synchronization** | Auto-blocking |

### Code Example

**Writer Process:**
```cpp
#include <fcntl.h>
#include <unistd.h>
#include <iostream>

int main() {
    const char* fifo_path = "/tmp/ipc_fifo";
    
    // Create FIFO if it doesn't exist
    mkfifo(fifo_path, 0666);
    
    // Open for writing
    int fd = open(fifo_path, O_WRONLY);
    
    const char* message = "Hello from writer!";
    write(fd, message, strlen(message));
    
    std::cout << "[WRITER] Sent message" << std::endl;
    close(fd);
    
    return 0;
}
```

**Reader Process:**
```cpp
#include <fcntl.h>
#include <unistd.h>
#include <iostream>

int main() {
    const char* fifo_path = "/tmp/ipc_fifo";
    
    // Open for reading
    int fd = open(fifo_path, O_RDONLY);
    
    char buffer[256];
    ssize_t n = read(fd, buffer, sizeof(buffer));
    
    if (n > 0) {
        buffer[n] = '\0';
        std::cout << "[READER] Received: " << buffer << std::endl;
    }
    
    close(fd);
    unlink(fifo_path);  // Cleanup
    
    return 0;
}
```

### When to Use
- ✅ Communication between unrelated processes
- ✅ Simple command-line tool integration
- ✅ One-way data flow needed
- ✅ Temporary named communication channel
- ❌ Not for high-performance scenarios
- ❌ Not for bidirectional communication

### Advantages
- Works between unrelated processes
- Persistent name (survives process exits)
- Automatic synchronization
- Simple to use and understand
- No external dependencies

### Disadvantages
- Unidirectional only
- Slower than anonymous pipes (disk involved)
- Limited capacity
- Requires file system cleanup

---

## 3. POSIX Message Queue

### What is it?
A **message queue** is an asynchronous communication mechanism that allows processes to exchange discrete messages in priority order. Unlike pipes, messages have priority levels and can be processed out-of-order.

### How it Works

```mermaid
graph TB
    Sender["Sender Process"]
    Queue["Message Queue<br/>(Kernel)<br/>Priority 0-31"]
    Receiver["Receiver Process"]
    
    Sender -->|mq_send<br/>Priority 5| Queue
    Sender -->|mq_send<br/>Priority 10| Queue
    Sender -->|mq_send<br/>Priority 3| Queue
    
    Queue -->|mq_receive<br/>Highest First| Receiver
    
    Order["Priority Order:<br/>10 → 5 → 3"]
    Queue -.-> Order
    
    style Queue fill:#99ff99
    style Sender fill:#99ccff
    style Receiver fill:#ffcc99
    style Order fill:#ffe6e6
```

**Data Flow:**
1. Sender writes message with priority level
2. Message stored in kernel queue (priority-sorted)
3. Receiver requests message from highest priority
4. Each message is discrete (not a stream)

### Key Characteristics

| Aspect | Detail |
|--------|--------|
| **Direction** | Bidirectional (two queues can exist) |
| **Scope** | Any processes |
| **Storage** | Kernel memory |
| **Capacity** | ~100 messages (configurable) |
| **Speed** | Medium (structured messages) |
| **Ordering** | Priority-based |
| **Synchronization** | Can be blocking or non-blocking |

### Code Example

**Sender Process:**
```cpp
#include <mqueue.h>
#include <iostream>

struct Message {
    int id;
    char text[256];
};

int main() {
    const char* queue_name = "/ipc_queue";
    
    // Open/create message queue
    mqd_t mq = mq_open(queue_name, 
                       O_CREAT | O_WRONLY, 
                       0644, NULL);
    
    Message msg;
    for (int i = 0; i < 3; i++) {
        msg.id = i;
        sprintf(msg.text, "Message %d", i);
        
        // Send with priority (higher number = higher priority)
        unsigned int priority = (3 - i) * 10;
        mq_send(mq, (char*)&msg, sizeof(msg), priority);
    }
    
    std::cout << "[SENDER] Sent 3 messages" << std::endl;
    mq_close(mq);
    
    return 0;
}
```

**Receiver Process:**
```cpp
#include <mqueue.h>
#include <iostream>

struct Message {
    int id;
    char text[256];
};

int main() {
    const char* queue_name = "/ipc_queue";
    
    // Open existing queue
    mqd_t mq = mq_open(queue_name, O_RDONLY);
    
    Message msg;
    unsigned int priority;
    
    // Receive messages in priority order
    while (mq_receive(mq, (char*)&msg, sizeof(msg), &priority) > 0) {
        std::cout << "[RECEIVER] Priority " << priority 
                  << ": " << msg.text << std::endl;
    }
    
    mq_close(mq);
    mq_unlink(queue_name);
    
    return 0;
}
```

### When to Use
- ✅ Task scheduling with priorities
- ✅ Asynchronous processing
- ✅ Producer-consumer with different message types
- ✅ Event handling with priority levels
- ❌ Not for real-time critical systems
- ❌ Not for large data (size limited)

### Advantages
- Priority-based ordering
- Asynchronous (non-blocking possible)
- Bidirectional communication
- Works between unrelated processes
- Messages are discrete units

### Disadvantages
- Linux-only (limited on macOS/Windows)
- Limited message size
- More overhead than pipes
- Requires careful cleanup
- Not suitable for streaming data

---

## 4. Shared Memory

### What is it?
**Shared memory** is the fastest IPC mechanism. It allows multiple processes to access the same memory region directly, without copying data. However, it requires explicit synchronization.

### How it Works

```mermaid
graph TB
    Writer["Writer Process"]
    SharedMem["Shared Memory<br/>(Kernel)<br/>int counter<br/>char message[128]"]
    Reader["Reader Process"]
    
    Writer -->|Direct Access| SharedMem
    Reader -->|Direct Access| SharedMem
    
    Memory["Physical RAM"]
    SharedMem -.-> Memory
    
    Warning["⚠️ Race Conditions!<br/>Need Synchronization"]
    
    style SharedMem fill:#ffff99
    style Writer fill:#99ccff
    style Reader fill:#99ccff
    style Memory fill:#e6e6e6
    style Warning fill:#ff9999
```

**Data Flow:**
1. Both processes attach to same memory segment
2. Writer modifies shared structure
3. Reader sees changes immediately (no copying)
4. **No buffer copying = Maximum speed**
5. **BUT: Race conditions possible**

### Key Characteristics

| Aspect | Detail |
|--------|--------|
| **Direction** | Bidirectional |
| **Scope** | Any processes |
| **Speed** | ⭐⭐⭐⭐⭐ (Fastest) |
| **Capacity** | Large (can be 1GB+) |
| **Storage** | Kernel memory or swap |
| **Synchronization** | **REQUIRED** (use semaphores) |
| **Data Copying** | Zero (direct memory access) |

### Code Example

**Data Structure (shared):**
```cpp
#include <cstring>

struct SharedData {
    int counter;
    char message[128];
};
```

**Writer Process:**
```cpp
#include <sys/shm.h>
#include <iostream>

int main() {
    // Create/get shared memory segment
    key_t key = ftok("/tmp", 'R');
    int shmid = shmget(key, sizeof(SharedData), IPC_CREAT | 0666);
    
    // Attach to shared memory
    SharedData* shared = (SharedData*)shmat(shmid, NULL, 0);
    
    // Write data (directly in shared memory!)
    for (int i = 0; i < 5; i++) {
        shared->counter = i;
        sprintf(shared->message, "Update %d from writer", i);
        
        std::cout << "[WRITER] Updated counter=" << shared->counter << std::endl;
        sleep(1);
    }
    
    // Detach (don't delete - reader still needs it)
    shmdt(shared);
    
    return 0;
}
```

**Reader Process:**
```cpp
#include <sys/shm.h>
#include <iostream>

int main() {
    // Get existing shared memory segment
    key_t key = ftok("/tmp", 'R');
    int shmid = shmget(key, sizeof(SharedData), 0);
    
    // Attach to shared memory
    SharedData* shared = (SharedData*)shmat(shmid, NULL, 0);
    
    // Read data (directly from shared memory!)
    for (int i = 0; i < 5; i++) {
        std::cout << "[READER] counter=" << shared->counter 
                  << ", message=" << shared->message << std::endl;
        sleep(1);
    }
    
    shmdt(shared);
    shmctl(shmid, IPC_RMID, NULL);  // Cleanup
    
    return 0;
}
```

### When to Use
- ✅ Maximum performance needed
- ✅ Real-time systems
- ✅ Large data exchange
- ✅ Frequent updates
- ❌ Uncoordinated access (without synchronization)

### Advantages
- ⭐⭐⭐⭐⭐ **Fastest IPC mechanism**
- No data copying
- Large capacity
- Low latency
- Bidirectional

### Disadvantages
- **Race conditions without synchronization**
- Requires careful memory management
- Complex debugging
- Must use semaphores/locks
- Data corruption risk

---

## 5. Semaphore Synchronization

### What is it?
A **semaphore** is a synchronization primitive that controls access to shared resources. It's typically a counter that can be incremented or decremented, blocking processes when necessary.

### How it Works

```mermaid
graph TB
    Writer["Writer Process"]
    Sem["Semaphore<br/>(Counter=1)"]
    Reader["Reader Process"]
    SharedMem["Shared Memory"]
    
    Writer -->|sem_wait<br/>Counter=0<br/>BLOCKED| Sem
    Reader -->|Critical<br/>Section| SharedMem
    Reader -->|sem_post<br/>Counter=1<br/>UNBLOCK| Sem
    
    style Sem fill:#ff9999
    style Writer fill:#99ccff
    style Reader fill:#99ccff
    style SharedMem fill:#ffff99
```

**Synchronization Flow:**
1. **sem_wait()**: Decrement counter
   - If counter > 0: Decrement and proceed
   - If counter = 0: **BLOCK** until incremented
2. **Critical Section**: Only one process at a time
3. **sem_post()**: Increment counter
   - Increment and wake up blocked process

### Key Characteristics

| Aspect | Detail |
|--------|--------|
| **Type** | Synchronization primitive (not IPC itself) |
| **Used With** | Shared memory, message queues |
| **Initial Value** | Usually 1 (binary semaphore) |
| **Atomicity** | Kernel ensures atomic operations |
| **Blocking** | Yes (when counter = 0) |
| **Use Case** | Mutual exclusion (mutex) |

### Code Example

**Mutual Exclusion Pattern:**
```cpp
#include <semaphore.h>
#include <iostream>

int main() {
    const char* sem_name = "/ipc_sem";
    
    // Create binary semaphore (initial value = 1)
    sem_t* sem = sem_open(sem_name, O_CREAT, 0644, 1);
    
    std::cout << "[PROCESS] Trying to enter critical section..." << std::endl;
    
    // Wait for semaphore (decrement, blocking if 0)
    sem_wait(sem);
    
    std::cout << "[PROCESS] ENTERED critical section" << std::endl;
    std::cout << "[PROCESS] Modifying shared data..." << std::endl;
    sleep(2);  // Simulate work
    
    std::cout << "[PROCESS] LEAVING critical section" << std::endl;
    
    // Signal semaphore (increment, wake up waiting process)
    sem_post(sem);
    
    sem_close(sem);
    sem_unlink(sem_name);
    
    return 0;
}
```

**Paired with Shared Memory:**
```cpp
#include <semaphore.h>
#include <sys/shm.h>
#include <iostream>

int main() {
    sem_t* mutex = sem_open("/mutex", O_CREAT, 0644, 1);
    
    // Get shared memory
    int shmid = shmget(ftok("/tmp", 'R'), sizeof(int), IPC_CREAT | 0666);
    int* counter = (int*)shmat(shmid, NULL, 0);
    
    // ===== PROTECTED CRITICAL SECTION =====
    sem_wait(mutex);        // Enter
    {
        int temp = *counter;  // Read
        temp++;               // Modify
        *counter = temp;      // Write
        std::cout << "Counter = " << *counter << std::endl;
    }
    sem_post(mutex);        // Exit
    // ======================================
    
    shmdt(counter);
    sem_close(mutex);
    
    return 0;
}
```

### When to Use
- ✅ Protecting shared memory access
- ✅ Preventing race conditions
- ✅ Producer-consumer coordination
- ✅ Resource pooling
- ❌ Not standalone (use with other IPC)

### Advantages
- Atomic operations guaranteed by kernel
- Simple and efficient
- Works with multiple processes
- Flexible (binary or counting)
- Low overhead

### Disadvantages
- Not standalone IPC mechanism
- Can cause deadlocks if misused
- Requires careful programming
- No automatic recovery from crashes
- Can lead to priority inversion

---

## 6. Signals / Events

### What is it?
**Signals** (Unix) are lightweight asynchronous notifications sent to processes. **Events** (Windows) are kernel objects that can be signaled to wake waiting threads/processes.

### How it Works

```mermaid
graph TB
    Sender["Sender Process"]
    Signal["Signal/Event<br/>(Kernel)"]
    Receiver["Receiver Process<br/>Handler Installed"]
    
    Sender -->|kill<br/>SIGUSR1| Signal
    Signal -->|Asynchronous<br/>Interrupt| Receiver
    Receiver -->|Handler<br/>Executes| Action["Update State"]
    
    style Signal fill:#ffcccc
    style Sender fill:#99ccff
    style Receiver fill:#99ff99
    style Action fill:#ffff99
```

**Signal Flow:**
1. Sender sends signal to receiver (by PID)
2. Kernel interrupts receiver process
3. Handler function executes (asynchronously)
4. Control returns to original code
5. **No data transfer** (just notification)

### Key Characteristics

| Aspect | Detail |
|--------|--------|
| **Direction** | Unidirectional |
| **Data Transfer** | None (notification only) |
| **Overhead** | ⭐⭐⭐⭐⭐ (Minimal) |
| **Latency** | ⭐⭐⭐⭐⭐ (Fastest) |
| **Common Signals** | SIGUSR1, SIGUSR2, SIGTERM, SIGINT |
| **Synchronization** | Automatic |
| **Reliability** | Not for critical messages |

### Code Example

**Signal-Based Notification:**
```cpp
#include <csignal>
#include <unistd.h>
#include <iostream>
#include <atomic>

std::atomic<int> signal_count(0);

void signal_handler(int sig) {
    if (sig == SIGUSR1) {
        signal_count++;
        std::cout << "[HANDLER] Received SIGUSR1 (count=" << signal_count << ")" << std::endl;
    }
}

int main() {
    // Install signal handler
    signal(SIGUSR1, signal_handler);
    
    std::cout << "[PROCESS] PID = " << getpid() << std::endl;
    std::cout << "[PROCESS] Waiting for signals..." << std::endl;
    
    // Wait for signals
    for (int i = 0; i < 5; i++) {
        pause();  // Wait for signal
    }
    
    std::cout << "[PROCESS] Received " << signal_count << " signals" << std::endl;
    
    return 0;
}
```

**Sending Signals:**
```cpp
#include <csignal>
#include <unistd.h>
#include <iostream>

int main() {
    pid_t target_pid = 12345;  // PID of receiver
    
    std::cout << "[SENDER] Sending signal to PID " << target_pid << std::endl;
    
    for (int i = 0; i < 5; i++) {
        kill(target_pid, SIGUSR1);
        std::cout << "[SENDER] Signal " << (i+1) << " sent" << std::endl;
        sleep(1);
    }
    
    return 0;
}
```

**Common Signals:**
```
SIGUSR1, SIGUSR2    - User-defined signals
SIGTERM             - Termination signal
SIGINT              - Interrupt (Ctrl+C)
SIGKILL             - Kill (cannot be caught)
SIGCHLD             - Child process changed state
SIGALRM             - Alarm clock
```

### When to Use
- ✅ Lightweight event notifications
- ✅ Periodic timer events
- ✅ Process lifecycle events
- ✅ Graceful shutdown triggers
- ❌ Not for data transfer
- ❌ Not for reliable messaging

### Advantages
- ⭐⭐⭐⭐⭐ **Fastest mechanism** (minimal overhead)
- Very lightweight
- Asynchronous
- Works between any processes
- Good for simple events

### Disadvantages
- No data transfer (notification only)
- Can be lost under load
- Async handling is complex
- Race conditions possible
- Limited reliability

---

## 7. Unix Domain Socket

### What is it?
A **Unix Domain Socket** (also called Unix socket or IPC socket) is a local inter-process communication mechanism similar to TCP/IP sockets but optimized for local processes on the same machine. On Windows, TCP sockets on localhost are used as a fallback.

### How it Works

```mermaid
graph TB
    Server["Server Process<br/>socket()<br/>bind()<br/>listen()"]
    Socket["Unix Socket<br/>/tmp/ipc.sock<br/>(named endpoint)"]
    Client["Client Process<br/>socket()<br/>connect()"]
    
    Server -->|bind| Socket
    Server -->|listen| Socket
    Client -->|connect| Socket
    
    Bidirectional["←→ Bidirectional<br/>Stream Connection"]
    Socket -.-> Bidirectional
    
    style Socket fill:#ffcccc
    style Server fill:#99ccff
    style Client fill:#99ff99
    style Bidirectional fill:#ffff99
```

**Connection Flow:**
1. Server creates, binds, and listens on socket
2. Client connects to socket
3. **Full-duplex** bidirectional stream
4. Data flows both ways simultaneously
5. Similar to TCP but **local only**

### Key Characteristics

| Aspect | Detail |
|--------|--------|
| **Direction** | Bidirectional (full-duplex) |
| **Scope** | Local machine only |
| **Speed** | Medium (faster than TCP, slower than shared memory) |
| **Capacity** | Large (streaming) |
| **Overhead** | Medium (socket abstraction) |
| **Persistence** | Socket file on disk |
| **Synchronization** | Automatic (blocking I/O) |

### Code Example

**Server Process:**
```cpp
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>
#include <iostream>
#include <cstring>

int main() {
    const char* socket_path = "/tmp/ipc.sock";
    unlink(socket_path);  // Remove old socket
    
    // Create Unix domain socket
    int server_fd = socket(AF_UNIX, SOCK_STREAM, 0);
    
    // Bind socket to path
    struct sockaddr_un addr;
    memset(&addr, 0, sizeof(addr));
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, socket_path, sizeof(addr.sun_path) - 1);
    
    bind(server_fd, (struct sockaddr*)&addr, sizeof(addr));
    listen(server_fd, 1);
    
    std::cout << "[SERVER] Listening on " << socket_path << std::endl;
    
    // Accept connection
    int client_fd = accept(server_fd, nullptr, nullptr);
    std::cout << "[SERVER] Client connected" << std::endl;
    
    // Bidirectional communication
    char buffer[256];
    ssize_t n = read(client_fd, buffer, sizeof(buffer));
    std::cout << "[SERVER] Received: " << buffer << std::endl;
    
    const char* response = "Hello from server!";
    write(client_fd, response, strlen(response));
    
    close(client_fd);
    close(server_fd);
    unlink(socket_path);
    
    return 0;
}
```

**Client Process:**
```cpp
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>
#include <iostream>
#include <cstring>

int main() {
    const char* socket_path = "/tmp/ipc.sock";
    
    // Create socket
    int client_fd = socket(AF_UNIX, SOCK_STREAM, 0);
    
    // Connect to server
    struct sockaddr_un addr;
    memset(&addr, 0, sizeof(addr));
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, socket_path, sizeof(addr.sun_path) - 1);
    
    connect(client_fd, (struct sockaddr*)&addr, sizeof(addr));
    std::cout << "[CLIENT] Connected to server" << std::endl;
    
    // Send message
    const char* message = "Hello from client!";
    write(client_fd, message, strlen(message));
    
    // Receive response
    char buffer[256];
    ssize_t n = read(client_fd, buffer, sizeof(buffer));
    std::cout << "[CLIENT] Received: " << buffer << std::endl;
    
    close(client_fd);
    
    return 0;
}
```

### When to Use
- ✅ Local client-server communication
- ✅ Better than pipes (bidirectional)
- ✅ No network complexity needed
- ✅ Database connections (local)
- ✅ Inter-process service calls
- ❌ Not for remote communication

### Advantages
- Bidirectional communication
- No network overhead
- Simple client-server model
- Good performance for local IPC
- File-based endpoint (easy to manage)
- Cross-platform (Unix/Linux/macOS/Windows TCP fallback)

### Disadvantages
- Local machine only
- Requires filesystem for socket file
- More overhead than pipes
- Connection-based (need to establish connection)
- Cleanup required

---

## 8. TCP Socket

### What is it?
**TCP sockets** are network sockets based on the TCP/IP protocol. They provide reliable, ordered, bidirectional communication over networks. When used on localhost, they're similar to Unix sockets but work across different machines.

### How it Works

```mermaid
graph TB
    Server["Server Process<br/>127.0.0.1:5555<br/>socket()<br/>bind()<br/>listen()"]
    Network["TCP Network<br/>(Can be local<br/>or remote)"]
    Client["Client Process<br/>127.0.0.1:random_port<br/>socket()<br/>connect()"]
    
    Server -->|listen| Network
    Client -->|connect| Network
    Network -->|ACK| Client
    Network -->|bidirectional| Server
    
    style Network fill:#99ccff
    style Server fill:#ffcc99
    style Client fill:#99ff99
```

**Connection Process (3-way handshake):**
1. Client initiates connection → SYN
2. Server acknowledges → SYN-ACK
3. Client confirms → ACK
4. **Connected**: Bidirectional data flow
5. Guaranteed ordering and delivery

### Key Characteristics

| Aspect | Detail |
|--------|--------|
| **Direction** | Bidirectional (full-duplex) |
| **Scope** | Local or remote |
| **Speed** | Medium (network overhead) |
| **Reliability** | High (TCP guarantees) |
| **Ordering** | Guaranteed |
| **Capacity** | Large (streaming) |
| **Error Handling** | Automatic retransmission |
| **Overhead** | Network stack processing |

### Code Example

**TCP Server:**
```cpp
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <iostream>
#include <cstring>

int main() {
    // Create TCP socket
    int server_fd = socket(AF_INET, SOCK_STREAM, 0);
    
    // Bind to port
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);  // 127.0.0.1
    addr.sin_port = htons(5555);
    
    int opt = 1;
    setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
    bind(server_fd, (struct sockaddr*)&addr, sizeof(addr));
    listen(server_fd, 5);  // Max 5 pending connections
    
    std::cout << "[TCP SERVER] Listening on 127.0.0.1:5555" << std::endl;
    
    // Accept connection
    struct sockaddr_in client_addr;
    socklen_t client_len = sizeof(client_addr);
    int client_fd = accept(server_fd, (struct sockaddr*)&client_addr, &client_len);
    
    std::cout << "[TCP SERVER] Client connected" << std::endl;
    
    // Receive data
    char buffer[256];
    ssize_t n = read(client_fd, buffer, sizeof(buffer));
    std::cout << "[TCP SERVER] Received: " << buffer << std::endl;
    
    // Send response
    const char* response = "Hello TCP client!";
    write(client_fd, response, strlen(response));
    
    close(client_fd);
    close(server_fd);
    
    return 0;
}
```

**TCP Client:**
```cpp
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <iostream>
#include <cstring>

int main() {
    // Create socket
    int client_fd = socket(AF_INET, SOCK_STREAM, 0);
    
    // Connect to server
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_port = htons(5555);
    inet_pton(AF_INET, "127.0.0.1", &addr.sin_addr);
    
    if (connect(client_fd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
        std::cerr << "Connection failed" << std::endl;
        return 1;
    }
    
    std::cout << "[TCP CLIENT] Connected to server" << std::endl;
    
    // Send request
    const char* request = "Hello TCP server!";
    write(client_fd, request, strlen(request));
    
    // Receive response
    char buffer[256];
    ssize_t n = read(client_fd, buffer, sizeof(buffer));
    std::cout << "[TCP CLIENT] Received: " << buffer << std::endl;
    
    close(client_fd);
    
    return 0;
}
```

### When to Use
- ✅ Remote communication needed
- ✅ Client-server architecture
- ✅ Network services (HTTP, SSH, etc.)
- ✅ Reliable data delivery required
- ✅ Ordered message delivery needed
- ✅ Cross-platform communication
- ❌ Not for real-time systems (latency)

### Advantages
- Bidirectional communication
- Works over networks (not just local)
- Guaranteed delivery and ordering
- Automatic error handling
- Well-standardized and portable
- Works across different operating systems
- Good for web services

### Disadvantages
- Higher overhead than local IPC
- Network latency (for remote)
- Connection management complexity
- Potential for network failures
- Not suitable for very high frequency updates
- More resource-intensive than pipes

---

## 9. Memory-Mapped File

### What is it?
A **memory-mapped file** maps a file from disk into a process's virtual address space. Multiple processes can map the same file and access it as if it were in RAM, with the OS handling disk I/O transparently.

### How it Works

```mermaid
graph TB
    Writer["Writer Process"]
    File["File on Disk<br/>/tmp/ipc.dat<br/>(Persistent)"]
    Memory["Virtual Memory<br/>(Kernel-managed)"]
    Reader["Reader Process"]
    
    Writer -->|mmap()| Memory
    Reader -->|mmap()| Memory
    Memory -->|sync| File
    
    Persistence["Data survives<br/>process exits"]
    File -.-> Persistence
    
    style Memory fill:#ffff99
    style File fill:#e6e6e6
    style Writer fill:#99ccff
    style Reader fill:#99ccff
    style Persistence fill:#99ff99
```

**Mapping Process:**
1. Create/open file on disk
2. Map file into memory (both processes)
3. Both access as regular memory
4. OS handles synchronization to disk
5. **Data persists** after process exits

### Key Characteristics

| Aspect | Detail |
|--------|--------|
| **Direction** | Bidirectional |
| **Scope** | Any processes |
| **Speed** | ⭐⭐⭐⭐⭐ (Same as shared memory) |
| **Persistence** | ✅ Yes (data on disk) |
| **Capacity** | Large (file size limit) |
| **Overhead** | Low (OS page cache) |
| **Synchronization** | Explicit (msync) or automatic |
| **Crash Safety** | High (data on disk) |

### Code Example

**Writer Process:**
```cpp
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>
#include <iostream>
#include <cstring>

struct DataBlock {
    int version;
    char content[256];
    long timestamp;
};

int main() {
    const char* filename = "/tmp/shared_data.dat";
    
    // Create/open file
    int fd = open(filename, O_CREAT | O_RDWR | O_TRUNC, 0666);
    
    // Resize file
    size_t size = sizeof(DataBlock);
    lseek(fd, size - 1, SEEK_SET);
    write(fd, "", 1);
    
    // Map file to memory
    DataBlock* data = (DataBlock*)mmap(nullptr, size, 
                                       PROT_READ | PROT_WRITE, 
                                       MAP_SHARED, fd, 0);
    
    // Write data directly to memory-mapped region
    for (int i = 0; i < 5; i++) {
        data->version = i;
        sprintf(data->content, "Update #%d from writer", i);
        data->timestamp = time(nullptr);
        
        std::cout << "[WRITER] Wrote version " << i << std::endl;
        
        // Sync to disk
        msync(data, size, MS_SYNC);
        sleep(1);
    }
    
    // Cleanup
    munmap(data, size);
    close(fd);
    
    return 0;
}
```

**Reader Process:**
```cpp
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>
#include <iostream>
#include <cstring>

struct DataBlock {
    int version;
    char content[256];
    long timestamp;
};

int main() {
    const char* filename = "/tmp/shared_data.dat";
    
    // Open existing file (read-only)
    int fd = open(filename, O_RDONLY);
    
    // Map file to memory
    size_t size = sizeof(DataBlock);
    DataBlock* data = (DataBlock*)mmap(nullptr, size, 
                                       PROT_READ, 
                                       MAP_SHARED, fd, 0);
    
    // Read data from memory-mapped region
    for (int i = 0; i < 5; i++) {
        std::cout << "[READER] Version " << data->version 
                  << ": " << data->content << std::endl;
        sleep(1);
    }
    
    // Cleanup
    munmap(data, size);
    close(fd);
    
    return 0;
}
```

### When to Use
- ✅ Large data sets
- ✅ Persistent data needed
- ✅ Maximum performance required
- ✅ Database caching
- ✅ Real-time data streaming
- ❌ Not for small messages
- ❌ Not for frequent synchronization

### Advantages
- ⭐⭐⭐⭐⭐ **Extremely fast** (memory-direct access)
- Data persists to disk
- Large capacity
- No data copying
- Bidirectional
- Efficient paging by OS

### Disadvantages
- Requires synchronization (semaphores)
- File cleanup necessary
- Memory fragmentation possible
- Complexity increases with file size
- Not suitable for real-time guarantees
- OS-specific behavior variations

---

## 10. RPC over TCP

### What is it?
**Remote Procedure Call (RPC)** over TCP is a high-level communication mechanism that allows a process to call functions/methods on another process as if they were local. Data is typically serialized (JSON, Protocol Buffers, etc.) for transmission.

### How it Works

```mermaid
graph TB
    Client["Client Process<br/>RPCCall"]
    Serializer["JSON Serializer<br/>{'method': 'add',<br/>'params': [5, 3]}"]
    Network["TCP Network<br/>(HTTP, TCP, etc.)"]
    Server["Server Process<br/>Handler"]
    Execute["Execute Method<br/>add(5, 3) = 8"]
    Response["Return Result<br/>{'result': 8}"]
    
    Client -->|Call| Serializer
    Serializer -->|Send| Network
    Network -->|Receive| Server
    Server -->|Dispatch| Execute
    Execute -->|Serialize| Response
    Response -->|Return| Client
    
    style Serializer fill:#99ff99
    style Network fill:#99ccff
    style Execute fill:#ffff99
```

**RPC Call Flow:**
1. Client calls method (like local function)
2. Serialize arguments to JSON
3. Send over TCP network
4. Server deserializes and dispatches
5. Execute actual method
6. Serialize result to JSON
7. Send back response
8. Client receives and returns result

### Key Characteristics

| Aspect | Detail |
|--------|--------|
| **Abstraction Level** | Highest (method calls) |
| **Direction** | Bidirectional |
| **Scope** | Local or remote |
| **Overhead** | High (serialization) |
| **Type Safety** | Can be high (with types) |
| **Language Support** | Multi-language possible |
| **Ease of Use** | Highest (looks like function calls) |
| **Performance** | Slower than lower-level IPC |

### Code Example

**RPC Server (exposing methods):**
```cpp
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <iostream>
#include <nlohmann/json.hpp>
#include <cstring>

using json = nlohmann::json;

// Exposed RPC methods
int add(int a, int b) { return a + b; }
int multiply(int a, int b) { return a * b; }
std::string concat(const std::string& a, const std::string& b) { return a + b; }

int main() {
    // Create TCP socket
    int server_fd = socket(AF_INET, SOCK_STREAM, 0);
    
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    addr.sin_port = htons(6666);
    
    int opt = 1;
    setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
    bind(server_fd, (struct sockaddr*)&addr, sizeof(addr));
    listen(server_fd, 1);
    
    std::cout << "[RPC SERVER] Listening on 127.0.0.1:6666" << std::endl;
    
    // Accept client
    int client_fd = accept(server_fd, nullptr, nullptr);
    
    // Receive RPC call
    char buffer[512];
    ssize_t n = read(client_fd, buffer, sizeof(buffer) - 1);
    buffer[n] = '\0';
    
    // Parse JSON request
    json request = json::parse(buffer);
    std::string method = request["method"];
    json params = request["params"];
    
    std::cout << "[RPC SERVER] Method: " << method << std::endl;
    
    // Dispatch to method and create response
    json response;
    response["id"] = request["id"];
    
    if (method == "add") {
        response["result"] = add(params["a"], params["b"]);
    } else if (method == "multiply") {
        response["result"] = multiply(params["a"], params["b"]);
    } else if (method == "concat") {
        response["result"] = concat(params["a"], params["b"]);
    }
    
    // Send response
    std::string response_str = response.dump();
    write(client_fd, response_str.c_str(), response_str.length());
    
    std::cout << "[RPC SERVER] Sent: " << response_str << std::endl;
    
    close(client_fd);
    close(server_fd);
    
    return 0;
}
```

**RPC Client (calling methods):**
```cpp
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <iostream>
#include <nlohmann/json.hpp>
#include <cstring>

using json = nlohmann::json;

int main() {
    // Connect to RPC server
    int client_fd = socket(AF_INET, SOCK_STREAM, 0);
    
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_port = htons(6666);
    inet_pton(AF_INET, "127.0.0.1", &addr.sin_addr);
    
    connect(client_fd, (struct sockaddr*)&addr, sizeof(addr));
    
    // Create RPC request (call add(5, 3))
    json request;
    request["jsonrpc"] = "2.0";
    request["id"] = 1;
    request["method"] = "add";
    request["params"] = {{"a", 5}, {"b", 3}};
    
    std::string request_str = request.dump();
    std::cout << "[RPC CLIENT] Calling: " << request_str << std::endl;
    
    // Send request
    write(client_fd, request_str.c_str(), request_str.length());
    
    // Receive response
    char buffer[512];
    ssize_t n = read(client_fd, buffer, sizeof(buffer) - 1);
    buffer[n] = '\0';
    
    json response = json::parse(buffer);
    
    std::cout << "[RPC CLIENT] Response: " << response.dump() << std::endl;
    std::cout << "[RPC CLIENT] Result: " << response["result"] << std::endl;
    
    close(client_fd);
    
    return 0;
}
```

### When to Use
- ✅ Service-oriented architecture
- ✅ Microservices communication
- ✅ Type-safe remote calls
- ✅ Multi-language systems
- ✅ REST/HTTP services
- ✅ Cross-network communication
- ❌ Not for real-time systems (overhead)
- ❌ Not for very high frequency calls

### Advantages
- Highest level of abstraction
- Method calls across processes (looks local)
- Type-safe (with schema)
- Language-independent (if using JSON/Protocol Buffers)
- Easy to understand and use
- Good for microservices
- Network-transparent

### Disadvantages
- **Highest overhead** (serialization/deserialization)
- Latency from network/serialization
- Debugging complexity
- Schema evolution challenges
- Not suitable for performance-critical code
- Requires proper error handling
- Network failures need handling

---

## Comparison Matrix

### Performance Characteristics

| Mechanism | Speed | Overhead | Best Use |
|-----------|-------|----------|----------|
| **Shared Memory** | ⭐⭐⭐⭐⭐ | Minimal | Real-time, high-frequency |
| **Memory-Mapped File** | ⭐⭐⭐⭐⭐ | Low | Large data + persistence |
| **Signals** | ⭐⭐⭐⭐⭐ | Minimal | Simple events |
| **Semaphore** | ⭐⭐⭐⭐ | Low | Synchronization |
| **Anonymous Pipe** | ⭐⭐⭐⭐ | Low | Parent-child only |
| **Unix Socket** | ⭐⭐⭐ | Medium | Local client-server |
| **Named Pipe** | ⭐⭐⭐ | Medium | Local unrelated processes |
| **TCP Socket** | ⭐⭐ | High | Remote + local |
| **Message Queue** | ⭐⭐ | Medium | Priority-based messaging |
| **RPC** | ⭐ | Very High | High-level abstraction |

### Feature Comparison

| Feature | Pipe | FIFO | MQ | SHM | SEM | Signals | UDS | TCP | MMAP | RPC |
|---------|------|------|----|----|-----|---------|-----|-----|------|-----|
| **Bidirectional** | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ |
| **Unrelated Processes** | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Remote** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ✅ |
| **Data Transfer** | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ |
| **Large Data** | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ |
| **Persistence** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |
| **Priority** | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Windows** | ✅ | ✅ | ❌ | ✅ | ✅ | ✅ | ✅* | ✅ | ✅ | ✅ |

*Windows uses TCP fallback

---

## Decision Tree

```
START: Choose an IPC Mechanism
  │
  ├─→ Only parent-child?
  │   └─→ YES: Use ANONYMOUS PIPE (#1)
  │
  ├─→ Need very high speed?
  │   ├─→ YES + Large data
  │   │   └─→ Use SHARED MEMORY (#4) + SEMAPHORE (#5)
  │   │
  │   ├─→ YES + Notification only
  │   │   └─→ Use SIGNALS (#6)
  │   │
  │   └─→ YES + Persistent needed
  │       └─→ Use MEMORY-MAPPED FILE (#9)
  │
  ├─→ Need local client-server?
  │   ├─→ YES + Bidirectional
  │   │   └─→ Use UNIX DOMAIN SOCKET (#7)
  │   │
  │   └─→ YES + Simple one-way
  │       └─→ Use NAMED PIPE (#2)
  │
  ├─→ Need remote communication?
  │   ├─→ YES + Simple protocols
  │   │   └─→ Use TCP SOCKET (#8)
  │   │
  │   └─→ YES + Type-safe methods
  │       └─→ Use RPC (#10)
  │
  └─→ Need priority-based messaging?
      └─→ YES: Use MESSAGE QUEUE (#3)
```

---

## Summary Table

| # | Name | Relation | Direction | Speed | Complexity | Use Case |
|---|------|----------|-----------|-------|------------|----------|
| 1 | Pipe | Parent-child | One-way | High | Low | Simple IPC |
| 2 | FIFO | Any | One-way | Medium | Low | Command piping |
| 3 | MQ | Any | Bidirectional | Medium | Medium | Priority tasks |
| 4 | Shared Mem | Any | Bidirectional | ⭐⭐⭐⭐⭐ | High | High-perf |
| 5 | Semaphore | Any | Sync | N/A | Medium | Locking |
| 6 | Signals | Any | One-way | ⭐⭐⭐⭐⭐ | Medium | Events |
| 7 | Unix Socket | Any | Bidirectional | High | Medium | Local services |
| 8 | TCP Socket | Any | Bidirectional | Medium | Medium | Network |
| 9 | MMAP | Any | Bidirectional | ⭐⭐⭐⭐⭐ | High | Large data |
| 10 | RPC | Any | Bidirectional | Low | Low | APIs |

---

This guide provides comprehensive understanding of all 10 IPC mechanisms with diagrams, code examples, and practical guidance for selecting the right mechanism for your use case.
