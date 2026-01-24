#!/bin/bash
# Quick Reference Commands for VLM Video Summarization Project
# Usage: source quick_commands.sh or add to ~/.bashrc

# Project directory
export VLM_PROJECT="/home/vaneet_2221cs15/vlmvideos/Vaneet_mam_vlm"
export VENV_PATH="/home/vaneet_2221cs15/vlmvideos/bin/activate"

# Navigation
alias vlm='cd $VLM_PROJECT'
alias activate='source $VENV_PATH'

# Training Commands
train_llava() {
    local gpu=${1:-0}
    local log_file=${2:-"training_run.log"}
    cd $VLM_PROJECT
    source $VENV_PATH
    nohup bash -c "PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True CUDA_VISIBLE_DEVICES=$gpu python scripts/03_finetune.py" > $log_file 2>&1 &
    echo "✅ LLaVA training started on GPU $gpu, log: $log_file"
    echo "Monitor: tail -f $log_file"
}

train_qwen() {
    local gpu=${1:-3}
    local log_file=${2:-"qwen_training.log"}
    cd $VLM_PROJECT
    source $VENV_PATH
    nohup bash -c "PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True CUDA_VISIBLE_DEVICES=$gpu python qwen_vlm/scripts/03_finetune_qwen.py" > $log_file 2>&1 &
    echo "✅ Qwen training started on GPU $gpu, log: $log_file"
    echo "Monitor: tail -f $log_file"
}

# Process Management
check_training() {
    echo "=== TRAINING STATUS ==="
    pgrep -f "03_finetune.py" > /dev/null && echo "✅ LLaVA training: RUNNING (PID: $(pgrep -f '03_finetune.py'))" || echo "❌ LLaVA training: STOPPED"
    pgrep -f "03_finetune_qwen.py" > /dev/null && echo "✅ Qwen training: RUNNING (PID: $(pgrep -f '03_finetune_qwen.py'))" || echo "❌ Qwen training: STOPPED"
}

stop_training() {
    pkill -f "03_finetune.py"
    pkill -f "03_finetune_qwen.py"
    echo "✅ All training processes stopped"
}

# GPU Management
check_gpu() {
    echo "=== GPU STATUS ==="
    nvidia-smi --query-gpu=index,memory.used,memory.total,utilization.gpu --format=csv,noheader | \
        awk -F', ' '{printf "GPU %d: %.1f/%.1f GB (%.1f%%), %s%% util\n", $1, $2/1024, $3/1024, ($2/$3)*100, $4}'
}

find_free_gpu() {
    echo "=== GPU WITH MOST FREE MEMORY ==="
    nvidia-smi --query-gpu=index,memory.used,memory.total --format=csv,noheader | \
        awk -F', ' '{free=($3-$2)/1024; printf "GPU %d: %.1f GB free\n", $1, free}' | \
        sort -k3 -rn | head -1
}

# Log Management
view_log() {
    local log_file=${1:-"training_run.log"}
    if [ -f "$VLM_PROJECT/$log_file" ]; then
        tail -f "$VLM_PROJECT/$log_file"
    else
        echo "❌ Log file not found: $log_file"
        echo "Available logs:"
        ls -1 $VLM_PROJECT/*.log 2>/dev/null | head -5
    fi
}

# Training Progress
check_progress() {
    echo "=== TRAINING PROGRESS ==="
    if [ -f "$VLM_PROJECT/results/training_loss.json" ]; then
        echo "Training Loss:"
        cat $VLM_PROJECT/results/training_loss.json | python3 -m json.tool | tail -10
    fi
    if [ -f "$VLM_PROJECT/results/validation_loss.json" ]; then
        echo ""
        echo "Validation Loss:"
        cat $VLM_PROJECT/results/validation_loss.json | python3 -m json.tool | tail -10
    fi
    echo ""
    echo "Checkpoints:"
    ls -1 $VLM_PROJECT/results/checkpoints/*.pt 2>/dev/null | wc -l | xargs echo "Total:"
}

# Complete Status
status() {
    check_training
    echo ""
    check_gpu
    echo ""
    check_progress
}

# Help
show_help() {
    echo "=== VLM PROJECT QUICK COMMANDS ==="
    echo ""
    echo "Training:"
    echo "  train_llava [gpu] [log_file]  - Start LLaVA training (default: GPU 0)"
    echo "  train_qwen [gpu] [log_file]    - Start Qwen training (default: GPU 3)"
    echo ""
    echo "Process Management:"
    echo "  check_training                - Check if training is running"
    echo "  stop_training                 - Stop all training processes"
    echo ""
    echo "GPU:"
    echo "  check_gpu                    - Show GPU status"
    echo "  find_free_gpu                - Find GPU with most free memory"
    echo ""
    echo "Logs:"
    echo "  view_log [log_file]          - View log file in real-time"
    echo ""
    echo "Progress:"
    echo "  check_progress               - Show training progress"
    echo "  status                       - Complete status check"
    echo ""
    echo "Navigation:"
    echo "  vlm                          - Go to project directory"
    echo "  activate                     - Activate virtual environment"
}

# Show help on source
echo "✅ VLM Project commands loaded!"
echo "Type 'show_help' for available commands"
