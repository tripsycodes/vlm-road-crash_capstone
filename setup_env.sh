#!/bin/bash
# setup_env.sh - Environment setup script for GPU execution

echo "============================================================"
echo "Setting up GPU environment for Car Crash Video Summarization"
echo "============================================================"

# CUDA paths (adjust based on your CUDA installation)
# Common locations:
# /usr/local/cuda
# /usr/local/cuda-11.8
# /usr/local/cuda-12.1

CUDA_VERSION=$(nvcc --version 2>/dev/null | grep "release" | sed 's/.*release \([0-9]\+\.[0-9]\+\).*/\1/')
if [ -z "$CUDA_VERSION" ]; then
    echo "Warning: CUDA not found in PATH. Trying common locations..."
    if [ -d "/usr/local/cuda" ]; then
        export CUDA_HOME=/usr/local/cuda
    elif [ -d "/usr/local/cuda-11.8" ]; then
        export CUDA_HOME=/usr/local/cuda-11.8
    elif [ -d "/usr/local/cuda-12.1" ]; then
        export CUDA_HOME=/usr/local/cuda-12.1
    else
        echo "Error: CUDA not found. Please set CUDA_HOME manually."
        exit 1
    fi
else
    export CUDA_HOME=/usr/local/cuda
fi

export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH

echo "CUDA_HOME: $CUDA_HOME"

# GPU selection (use GPU 0 by default, change if needed)
export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:-0}
echo "Using GPU: $CUDA_VISIBLE_DEVICES"

# PyTorch CUDA settings
export TORCH_CUDA_ARCH_LIST="7.0;7.5;8.0;8.6;8.9;9.0"

# Memory management (optional)
# export PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:512

# Activate virtual environment if exists
if [ -d "venv" ]; then
    source venv/bin/activate
    echo "Virtual environment activated"
else
    echo "Warning: Virtual environment not found. Create with: python3 -m venv venv"
fi

# Verify GPU
echo ""
echo "Verifying GPU availability..."
if command -v nvidia-smi &> /dev/null; then
    nvidia-smi --query-gpu=index,name,memory.total,memory.free --format=csv,noheader
    echo ""
    echo "GPU verification complete!"
else
    echo "Warning: nvidia-smi not found. GPU may not be available."
fi

echo ""
echo "============================================================"
echo "Environment setup complete!"
echo "============================================================"
echo ""
echo "To verify PyTorch CUDA support, run:"
echo "  python3 -c \"import torch; print('CUDA available:', torch.cuda.is_available())\""
echo ""

