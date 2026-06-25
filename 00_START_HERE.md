# 🎯 IPC Examples - START HERE

Welcome to the comprehensive C++ IPC examples project!

## ⚡ Quick Start (30 seconds)

```bash
# Navigate to the project
cd /Users/Voman.Kumar/Desktop/Code/ipc_examples

# Compile all examples
./build_all.sh

# Run a simple example
cd 01_anonymous_pipe
./pipe_example
```

**Expected output:**
```
[PARENT] Sent message via pipe
[CHILD] Received: Hello from parent process!
```

✅ You're running IPC!

---

## 📚 What You Just Ran

This project contains **10 different ways** for processes to communicate:

1. **Pipes** – Parent tells child
2. **Named Pipes** – Any local process can chat
3. **Message Queues** – Deliver messages with priority
4. **Shared Memory** – Blazing fast, shared data
5. **Semaphores** – Lock stuff safely
6. **Signals** – "Hey! Something happened!"
7. **Unix Sockets** – Local client-server
8. **TCP Sockets** – Talk over network
9. **Memory-Mapped Files** – Files as memory
10. **RPC** – Call remote functions like local ones

---

## 🗂️ Project Layout

```
ipc_examples/
├── 00_START_HERE.md          ← You are here
├── README.md                 ← Full overview
├── QUICK_REFERENCE.md        ← Copy-paste commands
├── PROJECT_SUMMARY.md        ← Stats & structure
├── INDEX.md                  ← Complete guide
├── build_all.sh              ← Compile everything
│
└── 01_anonymous_pipe/        ← 10 folders with examples
    ├── pipe_example.cpp
    ├── pipe_example          ← Ready to run
    └── README.md
    
├── 02_named_pipe_fifo/
├── 03_posix_message_queue/
├── ... (7 more folders)
└── 10_rpc_over_tcp/
```

---

## 🚀 Next Steps

### Step 1: Pick Your Interest
- **I want the fastest**: → [04_shared_memory/](04_shared_memory/)
- **I want simplicity**: → [01_anonymous_pipe/](01_anonymous_pipe/)
- **I want practical**: → [07_unix_domain_socket/](07_unix_domain_socket/)
- **I want networked**: → [08_tcp_socket/](08_tcp_socket/)
- **I want events**: → [06_signals/](06_signals/)

### Step 2: Read Its README
Each folder has a `README.md` with:
- What it is
- When to use it
- How to run it
- Key concepts

**Example**: 
```bash
cat 07_unix_domain_socket/README.md
```

### Step 3: Run It
```bash
# Single-process examples (run directly)
cd 01_anonymous_pipe && ./pipe_example

# Multi-process examples (need 2 terminals)
# Terminal 1:
cd 07_unix_domain_socket && ./uds_server

# Terminal 2:
cd 07_unix_domain_socket && ./uds_client
```

---

## 📖 Documentation Map

| I want to... | Read this |
|---|---|
| See all options | [README.md](README.md) |
| Copy-paste compile commands | [QUICK_REFERENCE.md](QUICK_REFERENCE.md) |
| Understand the project | [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) |
| Browse everything | [INDEX.md](INDEX.md) |
| See all 10 examples | [build_all.sh](build_all.sh) |

---

## 💡 Quick Decision: Which One Should I Use?

**Question**: How should my processes talk?

- **Parent ↔ Child only?** → Pipe ([01](01_anonymous_pipe/))
- **Local process ↔ process?** → Unix Socket ([07](07_unix_domain_socket/)) or Pipe ([02](02_named_pipe_fifo/))
- **Maximum speed needed?** → Shared Memory ([04](04_shared_memory/))
- **Talking over network?** → TCP Socket ([08](08_tcp_socket/)) or RPC ([10](10_rpc_over_tcp/))
- **Just send a notification?** → Signals ([06](06_signals/))
- **Priority-based messages?** → Message Queue ([03](03_posix_message_queue/))

---

## ✅ Checklist: Verify Everything Works

- [ ] Navigate to `/Users/Voman.Kumar/Desktop/Code/ipc_examples`
- [ ] Run `./build_all.sh` (should see ✓ for most items)
- [ ] Run `cd 01_anonymous_pipe && ./pipe_example` (should print parent/child msgs)
- [ ] Pick one that interests you
- [ ] Read its `README.md`
- [ ] Run its example
- [ ] Modify the code to experiment

---

## 🎓 Recommended Learning Order

1. **Start**: [01_anonymous_pipe](01_anonymous_pipe/) – Simplest concept
2. **Then**: [06_signals](06_signals/) – Quick events
3. **Next**: [07_unix_domain_socket](07_unix_domain_socket/) – Practical use
4. **Deep**: [04_shared_memory](04_shared_memory/) + [05_semaphore_sync](05_semaphore_sync/) – Advanced
5. **Extra**: [10_rpc_over_tcp](10_rpc_over_tcp/) – Modern patterns

---

## ⚠️ macOS Users

Most examples work on macOS! Two exceptions:

- **Message Queues** ([03](03_posix_message_queue/)) – Limited on macOS, use Linux for full support
- **RPC example** ([10](10_rpc_over_tcp/)) – Needs `nlohmann-json`:
  ```bash
  brew install nlohmann-json
  ```

The build script automatically skips unavailable ones.

---

## 📞 Common Questions

**Q: Can I modify the code?**  
A: Yes! They're examples. Try adding features, change messages, experiment.

**Q: How do I run two programs at once?**  
A: Open two terminal tabs/windows. Run server in one, client in other.

**Q: Why do some examples have warnings?**  
A: `sprintf` deprecation warnings on macOS are okay—they're for educational clarity.

**Q: Can I use these in production?**  
A: These are simplified examples. Production code needs more error handling, but the patterns are solid.

**Q: What if something doesn't compile?**  
A: Check [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for compilation flags, or re-run `./build_all.sh`.

---

## 🔗 Related Resources

- **Beej's Guide to Unix IPC**: https://beej.us/guide/bgipc/
- **Linux man pages**: `man 2 socket`, `man 7 ipc`
- **Book**: "Unix Network Programming" (Stevens & Rago)

---

## 🎉 You're All Set!

Pick an example folder above and start exploring. Each one is standalone and fully self-contained.

**Happy learning!** 🚀

---

**Path**: `/Users/Voman.Kumar/Desktop/Code/ipc_examples/`  
**Status**: ✅ All examples ready to run  
**Questions?**: Check the individual README.md files in each folder

