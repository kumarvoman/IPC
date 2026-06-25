#!/bin/bash

# IPC Examples - Build All Script
# Compiles all IPC examples
# Usage: ./build_all.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "========================================"
echo "Building All IPC Examples"
echo "========================================"

# 01 - Anonymous Pipe
echo "[1/10] Building Anonymous Pipe..."
cd 01_anonymous_pipe
g++ -o pipe_example pipe_example.cpp
echo "  ✓ pipe_example"
cd ..

# 02 - Named Pipe / FIFO
echo "[2/10] Building Named Pipe (FIFO)..."
cd 02_named_pipe_fifo
g++ -o fifo_reader fifo_reader.cpp
g++ -o fifo_writer fifo_writer.cpp
echo "  ✓ fifo_reader, fifo_writer"
cd ..

# 03 - POSIX Message Queue
echo "[3/10] Building POSIX Message Queue..."
cd 03_posix_message_queue
if g++ -o mq_receiver mq_receiver.cpp -lrt 2>/dev/null && g++ -o mq_sender mq_sender.cpp -lrt 2>/dev/null; then
    echo "  ✓ mq_receiver, mq_sender"
else
    echo "  ⚠ Skipping Message Queue (not available on macOS; use Linux)"
fi
cd ..

# 04 - Shared Memory
echo "[4/10] Building Shared Memory..."
cd 04_shared_memory
g++ -o shm_reader shm_reader.cpp
g++ -o shm_writer shm_writer.cpp
echo "  ✓ shm_reader, shm_writer"
cd ..

# 05 - Semaphore Synchronization
echo "[5/10] Building Semaphore Sync..."
cd 05_semaphore_sync
g++ -o sem_reader sem_reader.cpp
g++ -o sem_writer sem_writer.cpp
echo "  ✓ sem_reader, sem_writer"
cd ..

# 06 - Signals
echo "[6/10] Building Signals..."
cd 06_signals
g++ -o signal_example signal_example.cpp
echo "  ✓ signal_example"
cd ..

# 07 - Unix Domain Socket
echo "[7/10] Building Unix Domain Socket..."
cd 07_unix_domain_socket
g++ -o uds_server uds_server.cpp
g++ -o uds_client uds_client.cpp
echo "  ✓ uds_server, uds_client"
cd ..

# 08 - TCP Socket
echo "[8/10] Building TCP Socket..."
cd 08_tcp_socket
g++ -o tcp_server tcp_server.cpp
g++ -o tcp_client tcp_client.cpp
echo "  ✓ tcp_server, tcp_client"
cd ..

# 09 - Memory-Mapped File
echo "[9/10] Building Memory-Mapped File..."
cd 09_memory_mapped_file
g++ -o mmap_reader mmap_reader.cpp
g++ -o mmap_writer mmap_writer.cpp
echo "  ✓ mmap_reader, mmap_writer"
cd ..

# 10 - RPC over TCP (requires nlohmann-json)
echo "[10/10] Building RPC over TCP..."
cd 10_rpc_over_tcp
if [ -f "/usr/local/include/nlohmann/json.hpp" ] || [ -f "/opt/homebrew/include/nlohmann/json.hpp" ]; then
    g++ -std=c++17 -o rpc_server rpc_server.cpp
    g++ -std=c++17 -o rpc_client rpc_client.cpp
    echo "  ✓ rpc_server, rpc_client"
else
    echo "  ⚠ Skipping RPC example (nlohmann-json not found)"
    echo "    Install with: brew install nlohmann-json"
fi
cd ..

echo ""
echo "========================================"
echo "Build Complete!"
echo "========================================"
echo ""
echo "To run examples:"
echo "  cd 01_anonymous_pipe && ./pipe_example"
echo "  cd 06_signals && ./signal_example"
echo "  cd 07_unix_domain_socket && ./uds_server (terminal 1)"
echo "  cd 07_unix_domain_socket && ./uds_client (terminal 2)"
echo ""
echo "See individual README.md files for details."
