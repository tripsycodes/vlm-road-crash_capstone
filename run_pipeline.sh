#!/bin/bash
# run_pipeline.sh - Complete pipeline execution script

set -e  # Exit on error

echo "============================================================"
echo "Car Crash Video Summarization Pipeline"
echo "============================================================"
echo ""

# Step 1: Setup environment
echo "[Step 1] Setting up environment..."
source ./setup_env.sh

# Step 2: Verify GPU
echo ""
echo "[Step 2] Verifying GPU and PyTorch..."
python3 -c "
import torch
print(f'PyTorch version: {torch.__version__}')
print(f'CUDA available: {torch.cuda.is_available()}')
if torch.cuda.is_available():
    print(f'CUDA version: {torch.version.cuda}')
    print(f'GPU count: {torch.cuda.device_count()}')
    for i in range(torch.cuda.device_count()):
        print(f'GPU {i}: {torch.cuda.get_device_name(i)}')
        props = torch.cuda.get_device_properties(i)
        print(f'  Memory: {props.total_memory / 1e9:.2f} GB')
else:
    print('ERROR: CUDA not available!')
    exit(1)
"

# Step 3: Process data
echo ""
echo "[Step 3] Processing data..."
echo "This may take a while depending on the number of videos..."
python scripts/01_process_data.py

# Step 4: Run evaluation
echo ""
echo "[Step 4] Running zero-shot evaluation..."
echo "This will load the pretrained model and evaluate on test set..."
python scripts/02_evaluate_zero_shot.py

echo ""
echo "============================================================"
echo "Pipeline execution complete!"
echo "============================================================"
echo ""
echo "Results are saved in:"
echo "  - results/zero_shot/metrics.json"
echo "  - results/zero_shot/detailed_results.json"
echo ""
echo "To view results:"
echo "  cat results/zero_shot/metrics.json | python -m json.tool"
echo ""

