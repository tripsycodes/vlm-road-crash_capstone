# Setup and Execution Guide
## Complete Instructions for Running the Codebase with GPU Support

---

## 📋 Prerequisites

### 1. System Requirements
- **GPU**: NVIDIA GPU with CUDA support (recommended: A100, V100, or RTX 3090/4090)
- **CUDA**: Version 11.8 or 12.1+
- **Python**: 3.8 or higher
- **RAM**: At least 16GB (32GB+ recommended)
- **Storage**: Sufficient space for processed data and model weights

### 2. Check GPU Availability

```bash
# Check if GPU is available
nvidia-smi

# Expected output should show your GPU(s) with CUDA version
# Example:
# +-----------------------------------------------------------------------------+
# | NVIDIA-SMI 525.xx.xx    Driver Version: 525.xx.xx    CUDA Version: 12.0  |
# |-------------------------------+----------------------+----------------------+
# | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
# | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
# |===============================+======================+======================|
# |   0  NVIDIA A100         Off  | 00000000:00:04.0 Off |                    0 |
# | N/A   30C    P0    45W / 250W |      0MiB / 40960MiB |      0%      Default |
# +-------------------------------+----------------------+----------------------+
```

---

## 🚀 Step-by-Step Setup

### Step 1: Set Up Environment Variables

```bash
# Navigate to project directory
cd /home/vaneet_2221cs15/vlmvideos/Vaneet_mam_vlm

# Export CUDA paths (adjust based on your CUDA installation)
export CUDA_HOME=/usr/local/cuda
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH

# Set CUDA device (use specific GPU if multiple available)
export CUDA_VISIBLE_DEVICES=0  # Use GPU 0, change to 1, 2, etc. for other GPUs

# Set PyTorch to use GPU
export TORCH_CUDA_ARCH_LIST="7.0;7.5;8.0;8.6;8.9;9.0"  # Adjust based on your GPU architecture

# Optional: Set memory fraction (if you want to limit GPU memory usage)
export PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:512

# Verify CUDA is accessible
python3 -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}'); print(f'CUDA version: {torch.version.cuda}'); print(f'GPU count: {torch.cuda.device_count()}'); print(f'GPU name: {torch.cuda.get_device_name(0) if torch.cuda.is_available() else \"N/A\"}')"
```

### Step 2: Create Virtual Environment (Recommended)

```bash
# Create virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate

# Upgrade pip
pip install --upgrade pip
```

### Step 3: Install Dependencies

```bash
# Install PyTorch with CUDA support (adjust CUDA version as needed)
# For CUDA 11.8:
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# OR for CUDA 12.1:
# pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Install other dependencies
pip install -r requirements.txt

# Install additional packages if needed
pip install transformers accelerate peft
pip install opencv-python pillow pandas openpyxl
pip install nltk sacrebleu sentence-transformers
pip install pyyaml tqdm tensorboard
```

### Step 4: Download NLTK Data

```bash
python3 -c "import nltk; nltk.download('punkt', quiet=True); nltk.download('punkt_tab', quiet=True)"
```

### Step 5: Verify Installation

```bash
# Test GPU access
python3 -c "
import torch
print('=' * 60)
print('GPU Verification')
print('=' * 60)
print(f'PyTorch version: {torch.__version__}')
print(f'CUDA available: {torch.cuda.is_available()}')
if torch.cuda.is_available():
    print(f'CUDA version: {torch.version.cuda}')
    print(f'cuDNN version: {torch.backends.cudnn.version()}')
    print(f'GPU count: {torch.cuda.device_count()}')
    for i in range(torch.cuda.device_count()):
        print(f'GPU {i}: {torch.cuda.get_device_name(i)}')
        print(f'  Memory: {torch.cuda.get_device_properties(i).total_memory / 1e9:.2f} GB')
else:
    print('WARNING: CUDA not available!')
print('=' * 60)
"
```

---

## 🏃 Running the Codebase

### Option 1: Quick Setup Script

Create a setup script `setup_env.sh`:

```bash
#!/bin/bash
# setup_env.sh - Environment setup script

echo "Setting up environment..."

# CUDA paths (adjust based on your system)
export CUDA_HOME=/usr/local/cuda
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH

# GPU selection
export CUDA_VISIBLE_DEVICES=0

# Activate virtual environment if exists
if [ -d "venv" ]; then
    source venv/bin/activate
    echo "Virtual environment activated"
fi

# Verify GPU
echo "Verifying GPU..."
nvidia-smi --query-gpu=name,memory.total,memory.free --format=csv

echo "Environment setup complete!"
```

Make it executable:
```bash
chmod +x setup_env.sh
source setup_env.sh
```

### Option 2: Manual Execution

#### A. Process Data

```bash
# Set environment variables
export CUDA_VISIBLE_DEVICES=0

# Activate virtual environment (if using)
source venv/bin/activate

# Run data processing
python scripts/01_process_data.py
```

**Expected Output:**
```
============================================================
Data Processing Pipeline
============================================================

[Step 1] Collecting video files...
Found 1500 video files

[Step 2] Processing videos (extracting frames)...
Processing videos: 100%|████████████| 1500/1500 [XX:XX<00:00, X.XXit/s]
Processed: 1500 videos
Failed: 0 videos

[Step 3] Parsing ground truth annotations...
Excel columns: ['Video_ID', 'Text_Summary', ...]
Using video ID column: Video_ID
Using text column: Text_Summary
Total annotations: 1500
Average summary length: 45.2 words

[Step 4] Splitting dataset...
Train: 1050 videos
Val: 225 videos
Test: 225 videos
Saved split info to: data/processed/split_info.json

============================================================
Data processing complete!
============================================================
```

#### B. Run Zero-Shot Evaluation

```bash
# Set environment variables
export CUDA_VISIBLE_DEVICES=0

# Activate virtual environment (if using)
source venv/bin/activate

# Run zero-shot evaluation
python scripts/02_evaluate_zero_shot.py
```

**Expected Output:**
```
============================================================
Zero-Shot Evaluation
============================================================
Test videos: 225

Loading pretrained LLaVA-NeXT model...
Loaded LLaVA-1.5 model: llava-hf/llava-1.5-7b-hf

Running zero-shot evaluation...
Evaluating: 100%|████████████| 10/10 [XX:XX<00:00, X.XXit/s]

Computing BLEU scores...

Computing NLI scores...

============================================================
Evaluation Results
============================================================

Number of samples: 10

BLEU Scores:
  bleu_1: 0.4523        # Word-level match (45% of words match)
  bleu_2: 0.3421        # Phrase-level match (34% of word pairs match)
  bleu_3: 0.2890        # Longer phrase match (29% of triplets match)
  bleu_4: 0.2456        # Sentence-level match (25% of 4-word sequences match)
  bleu_corpus: 0.3123   # Average BLEU across all samples

NLI Scores:
  entailment_accuracy: 0.7000      # 70% of summaries are semantically correct
  contradiction_rate: 0.1000      # 10% contradict the reference (lower is better)
  neutral_rate: 0.2000             # 20% are unrelated (lower is better)
  avg_entailment_prob: 0.7234      # 72% average confidence in semantic correctness
  total_samples: 10

Results saved to: results/zero_shot
============================================================

📊 **Understanding the Scores:**
- BLEU measures word/phrase overlap (higher = more similar wording)
- NLI measures semantic correctness (higher entailment = more semantically correct)
- See EVALUATION_METRICS_EXPLAINED.md for detailed explanation
```

---

## 🔧 Advanced Configuration

### Using Multiple GPUs

```bash
# Use multiple GPUs (if available)
export CUDA_VISIBLE_DEVICES=0,1,2,3

# Or specify in Python code
import os
os.environ['CUDA_VISIBLE_DEVICES'] = '0,1'
```

### Memory Management

```bash
# Limit GPU memory usage
export PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:512

# Set memory fraction (use 80% of GPU memory)
export CUDA_MEMORY_FRACTION=0.8
```

### Mixed Precision Training

```bash
# Enable automatic mixed precision
export AMP_ENABLED=1
```

---

## 📝 Complete Execution Script

Create `run_pipeline.sh`:

```bash
#!/bin/bash
# run_pipeline.sh - Complete pipeline execution script

set -e  # Exit on error

echo "============================================================"
echo "Car Crash Video Summarization Pipeline"
echo "============================================================"

# Step 1: Setup environment
echo ""
echo "[Step 1] Setting up environment..."
export CUDA_HOME=/usr/local/cuda
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
export CUDA_VISIBLE_DEVICES=0

# Activate virtual environment
if [ -d "venv" ]; then
    source venv/bin/activate
fi

# Verify GPU
echo ""
echo "[Step 2] Verifying GPU..."
nvidia-smi --query-gpu=name,memory.total,memory.free --format=csv,noheader

# Step 3: Process data
echo ""
echo "[Step 3] Processing data..."
python scripts/01_process_data.py

# Step 4: Run evaluation
echo ""
echo "[Step 4] Running zero-shot evaluation..."
python scripts/02_evaluate_zero_shot.py

echo ""
echo "============================================================"
echo "Pipeline execution complete!"
echo "============================================================"
```

Make executable and run:
```bash
chmod +x run_pipeline.sh
./run_pipeline.sh
```

---

## 🐛 Troubleshooting

### Issue 1: CUDA Not Available

```bash
# Check CUDA installation
nvcc --version

# Check PyTorch CUDA support
python3 -c "import torch; print(torch.cuda.is_available())"

# Reinstall PyTorch with correct CUDA version
pip uninstall torch torchvision torchaudio
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
```

### Issue 2: Out of Memory (OOM)

```bash
# Reduce batch size in config/config.yaml
# Change: batch_size: 4 → batch_size: 2

# Or set memory fraction
export PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:256
```

### Issue 3: Model Loading Errors

```bash
# Clear cache
rm -rf ~/.cache/huggingface/

# Download model manually
python3 -c "
from transformers import LlavaProcessor, LlavaForConditionalGeneration
model_name = 'llava-hf/llava-1.5-7b-hf'
processor = LlavaProcessor.from_pretrained(model_name)
model = LlavaForConditionalGeneration.from_pretrained(model_name)
print('Model loaded successfully')
"
```

### Issue 4: Permission Errors

```bash
# Fix permissions
chmod +x scripts/*.py
chmod +x *.sh
```

---

## 📊 Monitoring GPU Usage

### During Execution

```bash
# Monitor GPU in real-time (separate terminal)
watch -n 1 nvidia-smi

# Or use
nvidia-smi -l 1  # Update every 1 second
```

### Check GPU Memory

```bash
# Check current GPU usage
nvidia-smi

# Check specific process
nvidia-smi --query-compute-apps=pid,process_name,used_memory --format=csv
```

---

## 🎯 Quick Reference Commands

```bash
# 1. Setup environment
export CUDA_VISIBLE_DEVICES=0
source venv/bin/activate

# 2. Process data
python scripts/01_process_data.py

# 3. Evaluate
python scripts/02_evaluate_zero_shot.py

# 4. Check results
cat results/zero_shot/metrics.json | python -m json.tool

# 5. Monitor GPU
watch -n 1 nvidia-smi
```

---

## ✅ Verification Checklist

Before running, verify:

- [ ] GPU is detected: `nvidia-smi` shows your GPU
- [ ] CUDA is available: `python -c "import torch; print(torch.cuda.is_available())"` returns `True`
- [ ] Dependencies installed: `pip list | grep torch` shows PyTorch
- [ ] Virtual environment activated: `which python` shows venv path
- [ ] Data files exist: `ls videos/*.mp4 | wc -l` shows 1500
- [ ] Ground truth exists: `ls "Car_Crash_Text_Dataset (3).xlsx"` exists

---

## 🚀 Production Run Example

```bash
#!/bin/bash
# production_run.sh

# Set all environment variables
export CUDA_HOME=/usr/local/cuda-11.8
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
export CUDA_VISIBLE_DEVICES=0
export PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:512

# Activate environment
source venv/bin/activate

# Run with logging
python scripts/01_process_data.py 2>&1 | tee logs/data_processing.log
python scripts/02_evaluate_zero_shot.py 2>&1 | tee logs/evaluation.log

echo "Execution complete. Check logs/ directory for details."
```

---

**Ready to run!** Follow these instructions step by step, and you'll have the codebase running on GPU in no time! 🎉

