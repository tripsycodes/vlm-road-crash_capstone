# 🚀 Experiment Commands Guide
**Complete Linux Commands for Running and Managing VLM Video Summarization Experiments**

**Last Updated:** January 8, 2026

---

## 📋 Table of Contents

1. [Background Training Commands](#background-training-commands)
2. [Process Management](#process-management)
3. [GPU Monitoring](#gpu-monitoring)
4. [Log Management](#log-management)
5. [File & Directory Management](#file--directory-management)
6. [Project-Specific Commands](#project-specific-commands)
7. [System Monitoring](#system-monitoring)
8. [Quick Reference](#quick-reference)

---

## 🎯 Background Training Commands

### Method 1: Using `nohup` (Recommended for Simple Background Jobs)

#### **LLaVA-NeXT Training in Background**

```bash
# Navigate to project directory
cd /home/vaneet_2221cs15/vlmvideos/Vaneet_mam_vlm

# Activate virtual environment
source /home/vaneet_2221cs15/vlmvideos/bin/activate

# Run training in background with nohup
nohup bash -c "PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True CUDA_VISIBLE_DEVICES=0 python scripts/03_finetune.py" > training_run.log 2>&1 &

# Explanation:
# - nohup: Prevents process from terminating when terminal closes
# - bash -c: Executes command in subshell
# - PYTORCH_CUDA_ALLOC_CONF: Memory optimization for PyTorch
# - CUDA_VISIBLE_DEVICES=0: Use GPU 0 (change to 1,2,3,4 for other GPUs)
# - > training_run.log: Redirect stdout to log file
# - 2>&1: Redirect stderr to stdout (same log file)
# - &: Run in background
```

#### **Qwen-VL Training in Background**

```bash
cd /home/vaneet_2221cs15/vlmvideos/Vaneet_mam_vlm
source /home/vaneet_2221cs15/vlmvideos/bin/activate

# Run Qwen training on specific GPU
nohup bash -c "PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True CUDA_VISIBLE_DEVICES=3 python qwen_vlm/scripts/03_finetune_qwen.py" > qwen_training.log 2>&1 &
```

#### **With Cleanup (Remove old loss files before training)**

```bash
cd /home/vaneet_2221cs15/vlmvideos/Vaneet_mam_vlm
source /home/vaneet_2221cs15/vlmvideos/bin/activate

# Clean old results and start fresh
rm -f results/training_loss.json results/validation_loss.json
nohup bash -c "PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True CUDA_VISIBLE_DEVICES=0 python scripts/03_finetune.py" > training_run.log 2>&1 &
```

---

### Method 2: Using `screen` (Recommended for Interactive Sessions)

#### **Installation (if not installed)**
```bash
sudo apt-get install screen  # Ubuntu/Debian
```

#### **Start Training in Screen Session**

```bash
# Start a new screen session named "training"
screen -S training

# Inside screen, run your training
cd /home/vaneet_2221cs15/vlmvideos/Vaneet_mam_vlm
source /home/vaneet_2221cs15/vlmvideos/bin/activate
PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True CUDA_VISIBLE_DEVICES=0 python scripts/03_finetune.py

# Detach from screen: Press Ctrl+A, then D
# Reattach: screen -r training
# List sessions: screen -ls
# Kill session: screen -X -S training quit
```

#### **Screen Commands Cheat Sheet**
```bash
# Create new session
screen -S session_name

# List all sessions
screen -ls

# Attach to session
screen -r session_name

# Detach (from inside screen): Ctrl+A, then D

# Kill session
screen -X -S session_name quit

# Split screen horizontally: Ctrl+A, then S
# Switch panes: Ctrl+A, then Tab
# Close pane: Ctrl+A, then X
```

---

### Method 3: Using `tmux` (Advanced - Better than screen)

#### **Installation**
```bash
sudo apt-get install tmux  # Ubuntu/Debian
```

#### **Start Training in Tmux Session**

```bash
# Create new tmux session
tmux new -s training

# Inside tmux, run training
cd /home/vaneet_2221cs15/vlmvideos/Vaneet_mam_vlm
source /home/vaneet_2221cs15/vlmvideos/bin/activate
PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True CUDA_VISIBLE_DEVICES=0 python scripts/03_finetune.py

# Detach: Ctrl+B, then D
# Attach: tmux attach -t training
# List: tmux ls
# Kill: tmux kill-session -t training
```

#### **Tmux Commands Cheat Sheet**
```bash
# Create session
tmux new -s session_name

# List sessions
tmux ls

# Attach to session
tmux attach -t session_name

# Detach (from inside): Ctrl+B, then D

# Split window horizontally: Ctrl+B, then %
# Split window vertically: Ctrl+B, then "
# Switch panes: Ctrl+B, then arrow keys
# Kill session: tmux kill-session -t session_name
```

---

## 🔄 Process Management

### **Check Running Training Processes**

```bash
# Find all training processes
ps aux | grep "03_finetune"

# Find specific process
pgrep -f "03_finetune.py"

# Check if process is running
pgrep -f "03_finetune.py" && echo "Running" || echo "Not running"

# Detailed process info
ps aux | grep "03_finetune" | grep -v grep
```

### **Stop/Kill Training Processes**

```bash
# Graceful stop (sends SIGTERM)
pkill -f "03_finetune.py"

# Force kill (sends SIGKILL)
pkill -9 -f "03_finetune.py"

# Kill specific process by PID
kill <PID>
kill -9 <PID>  # Force kill

# Kill all Python training processes
pkill -f "python.*finetune"
```

### **Monitor Process Status**

```bash
# Real-time process monitoring
watch -n 1 'ps aux | grep finetune | grep -v grep'

# Check process CPU/Memory usage
top -p $(pgrep -f "03_finetune.py")

# Or use htop (more user-friendly)
htop -p $(pgrep -f "03_finetune.py")
```

### **Check Process Details**

```bash
# Get PID and details
ps aux | grep "03_finetune" | grep -v grep | awk '{print "PID:", $2, "| CPU:", $3"%", "| Memory:", $4"%", "| Status:", $8}'

# Check process tree
pstree -p $(pgrep -f "03_finetune.py")

# Check process environment
cat /proc/$(pgrep -f "03_finetune.py")/environ | tr '\0' '\n'
```

---

## 🖥️ GPU Monitoring

### **Check GPU Status**

```bash
# Basic GPU info
nvidia-smi

# Continuous monitoring (updates every 1 second)
watch -n 1 nvidia-smi

# Specific GPU info
nvidia-smi -i 0  # GPU 0
nvidia-smi -i 1  # GPU 1

# Memory usage only
nvidia-smi --query-gpu=index,memory.used,memory.total --format=csv

# Utilization only
nvidia-smi --query-gpu=index,utilization.gpu --format=csv

# All GPUs with memory and utilization
nvidia-smi --query-gpu=index,memory.used,memory.total,utilization.gpu --format=csv,noheader | \
  awk -F', ' '{printf "GPU %d: %.1f/%.1f GB (%.1f%%), %s%% util\n", $1, $2/1024, $3/1024, ($2/$3)*100, $4}'
```

### **Find Which GPU Has Most Free Memory**

```bash
# Find GPU with most free memory
nvidia-smi --query-gpu=index,memory.used,memory.total --format=csv,noheader | \
  awk -F', ' '{free=($3-$2)/1024; printf "GPU %d: %.1f GB free\n", $1, free}' | \
  sort -k3 -rn
```

### **Check GPU Processes**

```bash
# See what's running on each GPU
nvidia-smi pmon

# Detailed process info
nvidia-smi --query-compute-apps=pid,process_name,used_memory --format=csv

# Find processes using specific GPU
fuser -v /dev/nvidia0  # GPU 0
fuser -v /dev/nvidia1  # GPU 1
```

### **Kill Process on Specific GPU**

```bash
# Find PID using GPU 0
nvidia-smi --query-compute-apps=pid --format=csv,noheader -i 0

# Kill all processes on GPU 0
sudo fuser -k /dev/nvidia0
```

---

## 📝 Log Management

### **View Logs in Real-Time**

```bash
# Follow log file (like tail -f)
tail -f training_run.log

# Follow with line numbers
tail -f -n 100 training_run.log

# Follow multiple logs
tail -f training_run.log qwen_training.log

# Follow last N lines
tail -n 50 training_run.log
```

### **Search Logs**

```bash
# Search for errors
grep -i "error" training_run.log

# Search for specific patterns
grep -i "epoch\|loss\|nan" training_run.log

# Search with context (5 lines before/after)
grep -i "error" -A 5 -B 5 training_run.log

# Count occurrences
grep -c "error" training_run.log

# Search in multiple files
grep -r "error" *.log
```

### **View Log Statistics**

```bash
# Last 50 lines
tail -50 training_run.log

# First 50 lines
head -50 training_run.log

# Lines 100-200
sed -n '100,200p' training_run.log

# Count total lines
wc -l training_run.log

# File size
ls -lh training_run.log
```

### **Clean Old Logs**

```bash
# Delete all log files
find . -name "*.log" -type f -delete

# Delete logs older than 7 days
find . -name "*.log" -type f -mtime +7 -delete

# Archive logs
tar -czf logs_backup_$(date +%Y%m%d).tar.gz *.log
rm *.log
```

---

## 📁 File & Directory Management

### **Navigation**

```bash
# Go to project directory
cd /home/vaneet_2221cs15/vlmvideos/Vaneet_mam_vlm

# Go to parent directory
cd ..

# Go to home directory
cd ~
cd

# Go to previous directory
cd -

# Show current directory
pwd
```

### **List Files**

```bash
# List files
ls

# List with details
ls -lh

# List all (including hidden)
ls -la

# List sorted by size
ls -lhS

# List sorted by modification time
ls -lht

# List only directories
ls -d */

# List only Python files
ls *.py

# Recursive list
ls -R
```

### **File Operations**

```bash
# Copy file
cp source.txt destination.txt

# Copy directory
cp -r source_dir/ destination_dir/

# Move/rename file
mv old_name.txt new_name.txt

# Delete file
rm file.txt

# Delete directory
rm -r directory/

# Force delete (no confirmation)
rm -rf directory/

# Create directory
mkdir new_directory

# Create nested directories
mkdir -p path/to/nested/directory
```

### **File Search**

```bash
# Find files by name
find . -name "*.py"

# Find files by size (larger than 100MB)
find . -size +100M

# Find files modified in last 24 hours
find . -mtime -1

# Find and delete
find . -name "*.log" -type f -delete

# Find and execute command
find . -name "*.py" -exec chmod +x {} \;
```

### **Disk Usage**

```bash
# Check directory size
du -sh directory_name/

# Check all subdirectories
du -h --max-depth=1

# Sort by size
du -h --max-depth=1 | sort -h

# Check total disk space
df -h

# Check specific directory
du -sh /home/vaneet_2221cs15/vlmvideos/Vaneet_mam_vlm
```

---

## 🎯 Project-Specific Commands

### **Data Processing**

```bash
cd /home/vaneet_2221cs15/vlmvideos/Vaneet_mam_vlm
source /home/vaneet_2221cs15/vlmvideos/bin/activate

# Process dataset
python scripts/01_process_data.py
```

### **Zero-Shot Evaluation**

```bash
cd /home/vaneet_2221cs15/vlmvideos/Vaneet_mam_vlm
source /home/vaneet_2221cs15/vlmvideos/bin/activate

# Run zero-shot evaluation
python scripts/02_evaluate_zero_shot.py
```

### **Fine-Tuning**

```bash
cd /home/vaneet_2221cs15/vlmvideos/Vaneet_mam_vlm
source /home/vaneet_2221cs15/vlmvideos/bin/activate

# LLaVA-NeXT fine-tuning (foreground)
python scripts/03_finetune.py

# LLaVA-NeXT fine-tuning (background)
nohup bash -c "PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True CUDA_VISIBLE_DEVICES=0 python scripts/03_finetune.py" > training_run.log 2>&1 &

# Qwen-VL fine-tuning (background)
nohup bash -c "PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True CUDA_VISIBLE_DEVICES=3 python qwen_vlm/scripts/03_finetune_qwen.py" > qwen_training.log 2>&1 &
```

### **Fine-Tuned Evaluation**

```bash
cd /home/vaneet_2221cs15/vlmvideos/Vaneet_mam_vlm
source /home/vaneet_2221cs15/vlmvideos/bin/activate

# Evaluate fine-tuned model
python scripts/04_evaluate_finetuned.py
```

### **Compare Results**

```bash
cd /home/vaneet_2221cs15/vlmvideos/Vaneet_mam_vlm
source /home/vaneet_2221cs15/vlmvideos/bin/activate

# Compare zero-shot vs fine-tuned
python scripts/05_compare_results.py
```

### **Check Training Progress**

```bash
# View training loss
cat results/training_loss.json | python -m json.tool

# View validation loss
cat results/validation_loss.json | python -m json.tool

# Check checkpoint files
ls -lh results/checkpoints/

# Check best checkpoint
ls -lh results/checkpoints/best_checkpoint.pt

# Count checkpoints
ls -1 results/checkpoints/*.pt | wc -l
```

### **Virtual Environment**

```bash
# Activate virtual environment
source /home/vaneet_2221cs15/vlmvideos/bin/activate

# Deactivate
deactivate

# Check Python version
python --version

# Check installed packages
pip list

# Install requirements
pip install -r requirements.txt
```

---

## 📊 System Monitoring

### **CPU & Memory**

```bash
# CPU and memory usage
top

# More user-friendly
htop

# Memory usage
free -h

# CPU info
lscpu

# Load average
uptime
```

### **Disk I/O**

```bash
# Disk I/O statistics
iostat -x 1

# Disk usage by filesystem
df -h

# Find large files
find / -size +1G 2>/dev/null
```

### **Network**

```bash
# Network statistics
netstat -tuln

# Active connections
ss -tuln

# Network traffic
iftop
```

---

## 🔧 Useful Utility Commands

### **Text Processing**

```bash
# Count lines in file
wc -l file.txt

# Count words
wc -w file.txt

# View file with line numbers
cat -n file.txt

# View file page by page
less file.txt
more file.txt

# Search and replace in file
sed -i 's/old_text/new_text/g' file.txt
```

### **Compression**

```bash
# Create tar archive
tar -czf archive.tar.gz directory/

# Extract tar archive
tar -xzf archive.tar.gz

# Create zip
zip -r archive.zip directory/

# Extract zip
unzip archive.zip
```

### **Permissions**

```bash
# Change file permissions
chmod 755 script.py

# Make executable
chmod +x script.py

# Change ownership
sudo chown user:group file.txt
```

### **Background Jobs**

```bash
# List background jobs
jobs

# Bring job to foreground
fg %1

# Send job to background
bg %1

# Disown job (survives terminal close)
disown %1
```

---

## ⚡ Quick Reference

### **Most Used Commands**

```bash
# 1. Start training in background
cd /home/vaneet_2221cs15/vlmvideos/Vaneet_mam_vlm
source /home/vaneet_2221cs15/vlmvideos/bin/activate
nohup bash -c "PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True CUDA_VISIBLE_DEVICES=0 python scripts/03_finetune.py" > training.log 2>&1 &

# 2. Check if training is running
pgrep -f "03_finetune.py" && echo "Running" || echo "Not running"

# 3. Monitor GPU
watch -n 1 nvidia-smi

# 4. View training log
tail -f training.log

# 5. Check training progress
cat results/training_loss.json | python -m json.tool

# 6. Stop training
pkill -f "03_finetune.py"

# 7. Check GPU memory
nvidia-smi --query-gpu=index,memory.used,memory.total --format=csv

# 8. Find free GPU
nvidia-smi --query-gpu=index,memory.used,memory.total --format=csv,noheader | \
  awk -F', ' '{free=($3-$2)/1024; printf "GPU %d: %.1f GB free\n", $1, free}' | \
  sort -k3 -rn
```

### **Emergency Commands**

```bash
# Kill all training processes
pkill -9 -f "finetune"

# Free GPU memory (kill all processes on GPU 0)
sudo fuser -k /dev/nvidia0

# Clear Python cache
find . -type d -name __pycache__ -exec rm -r {} +
find . -name "*.pyc" -delete

# Clear CUDA cache (in Python)
python -c "import torch; torch.cuda.empty_cache()"
```

### **Project Status Check**

```bash
# Complete status check
echo "=== TRAINING STATUS ===" && \
pgrep -f "03_finetune.py" && echo "✅ LLaVA training running" || echo "❌ LLaVA training stopped" && \
pgrep -f "03_finetune_qwen.py" && echo "✅ Qwen training running" || echo "❌ Qwen training stopped" && \
echo "" && \
echo "=== GPU STATUS ===" && \
nvidia-smi --query-gpu=index,memory.used,utilization.gpu --format=csv,noheader | \
  awk -F', ' '{printf "GPU %d: %.1f GB used, %s%% util\n", $1, $2/1024, $3}' && \
echo "" && \
echo "=== CHECKPOINTS ===" && \
ls -1 results/checkpoints/*.pt 2>/dev/null | wc -l && echo "checkpoints saved"
```

---

## 📚 Additional Resources

### **Learning Linux Commands**

```bash
# Get help for any command
man command_name
command_name --help

# Examples:
man ls
man grep
nvidia-smi --help
```

### **Useful Aliases (Add to ~/.bashrc)**

```bash
# Add these to ~/.bashrc for convenience

# Project navigation
alias vlm='cd /home/vaneet_2221cs15/vlmvideos/Vaneet_mam_vlm'
alias activate='source /home/vaneet_2221cs15/vlmvideos/bin/activate'

# GPU monitoring
alias gpu='nvidia-smi'
alias gpuwatch='watch -n 1 nvidia-smi'

# Training status
alias trainstatus='pgrep -f "03_finetune" && echo "Training running" || echo "Training stopped"'

# Log viewing
alias taillog='tail -f training_run.log'
```

After adding aliases, reload:
```bash
source ~/.bashrc
```

---

## 🎓 Best Practices

1. **Always use nohup or screen/tmux** for long-running training
2. **Monitor GPU usage** before starting training
3. **Check available disk space** before training (checkpoints are large)
4. **Use log files** to track training progress
5. **Kill processes gracefully** (pkill before kill -9)
6. **Clean up old logs** periodically
7. **Backup important checkpoints** before deleting

---

**Last Updated:** January 8, 2026  
**For Issues:** Check logs first, then check GPU status, then check process status
