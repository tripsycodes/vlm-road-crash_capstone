# Quick Start Guide 🚀

## ⚡ Fastest Way to Run

### 1. One-Time Setup

```bash
# Navigate to project
cd /home/vaneet_2221cs15/vlmvideos/Vaneet_mam_vlm

# Setup environment (auto-detects CUDA)
source setup_env.sh

# Install dependencies
pip install -r requirements.txt
```

### 2. Run Complete Pipeline

```bash
# Run everything (data processing + evaluation)
./run_pipeline.sh
```

---

## 🔧 Manual Step-by-Step

### Step 1: Setup GPU Environment

```bash
# Export CUDA paths
export CUDA_HOME=/usr/local/cuda
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH

# Select GPU
export CUDA_VISIBLE_DEVICES=0

# Verify GPU
nvidia-smi
```

### Step 2: Activate Environment

```bash
# Activate virtual environment (if using)
source venv/bin/activate
```

### Step 3: Process Data

```bash
python scripts/01_process_data.py
```

### Step 4: Run Evaluation

```bash
python scripts/02_evaluate_zero_shot.py
```

---

## 📋 Essential Commands

```bash
# Check GPU
nvidia-smi

# Verify PyTorch CUDA
python -c "import torch; print(torch.cuda.is_available())"

# Process data
python scripts/01_process_data.py

# Evaluate
python scripts/02_evaluate_zero_shot.py

# View results
cat results/zero_shot/metrics.json | python -m json.tool
```

---

## 🐛 Quick Troubleshooting

| Issue | Solution |
|-------|----------|
| CUDA not available | `pip install torch --index-url https://download.pytorch.org/whl/cu118` |
| Out of memory | Reduce batch size in `config/config.yaml` |
| Permission denied | `chmod +x scripts/*.py` |
| Module not found | `pip install -r requirements.txt` |

---

## 📊 Expected Output Locations

- **Processed data**: `data/processed/`
- **Results**: `results/zero_shot/`
- **Metrics**: `results/zero_shot/metrics.json`
- **Loss logs**: `results/training_loss.json`

---

**For detailed instructions, see `SETUP_AND_RUN.md`**

