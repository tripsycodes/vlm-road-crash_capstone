# Qwen-VL Fine-Tuning for Video Summarization

This directory contains the fine-tuning setup for Qwen-VL (Qwen2-VL-7B-Instruct) model for car crash video summarization.

## Structure

```
qwen_vlm/
├── config/
│   └── config_qwen.yaml          # Configuration file
├── scripts/
│   └── 03_finetune_qwen.py        # Fine-tuning script
├── src/
│   ├── models/
│   │   └── qwen_wrapper.py        # Qwen-VL model wrapper
│   ├── training/
│   │   └── loss_tracker.py        # Loss tracking utilities
│   └── utils/
│       └── config.py              # Configuration utilities
└── results/
    ├── checkpoints/               # Saved model checkpoints
    └── logs/                      # Training logs
```

## Setup

1. Make sure you have the required dependencies:
   ```bash
   pip install transformers peft bitsandbytes torch torchvision
   ```

2. Ensure the dataset is processed (same as LLaVA setup):
   ```bash
   cd /home/vaneet_2221cs15/vlmvideos/Vaneet_mam_vlm
   python scripts/01_process_data.py
   ```

## Running Fine-Tuning

### Basic Usage

```bash
cd /home/vaneet_2221cs15/vlmvideos/Vaneet_mam_vlm
python qwen_vlm/scripts/03_finetune_qwen.py
```

### With Custom Config

```bash
python qwen_vlm/scripts/03_finetune_qwen.py --config qwen_vlm/config/config_qwen.yaml
```

### Run in Background

```bash
nohup python qwen_vlm/scripts/03_finetune_qwen.py > qwen_training.log 2>&1 &
```

### With Specific GPU

```bash
CUDA_VISIBLE_DEVICES=0 python qwen_vlm/scripts/03_finetune_qwen.py
```

## Configuration

Edit `qwen_vlm/config/config_qwen.yaml` to adjust:
- Model name (default: `Qwen/Qwen2-VL-7B-Instruct`)
- Batch size
- Learning rate
- Number of epochs
- Gradient clipping
- Save directories

## Features

- **LoRA Fine-Tuning**: Uses Parameter-Efficient Fine-Tuning (LoRA) to reduce memory usage
- **8-bit Quantization**: Automatically uses 8-bit quantization if available
- **NaN Detection**: Monitors and handles NaN losses during training
- **Gradient Clipping**: Prevents gradient explosion
- **Loss Tracking**: Saves training and validation losses to JSON files
- **Checkpoint Saving**: Saves checkpoints after each epoch and best model

## Differences from LLaVA Setup

1. **Input Format**: Qwen-VL uses chat template format with messages instead of USER/ASSISTANT format
2. **Processor API**: Uses `apply_chat_template` and `process_vision_info` methods
3. **Model Architecture**: Different model structure (Qwen2-VL vs LLaVA-NeXT)

## Monitoring Training

Check training progress:
```bash
# View log file
tail -f qwen_training.log

# Check loss files
cat qwen_vlm/results/training_loss.json
cat qwen_vlm/results/validation_loss.json

# Check GPU usage
nvidia-smi
```

## Output

- **Checkpoints**: Saved in `qwen_vlm/results/checkpoints/`
  - `checkpoint_epoch_N.pt`: Checkpoint after each epoch
  - `best_checkpoint.pt`: Best model based on validation loss
- **Loss Files**: 
  - `qwen_vlm/results/training_loss.json`
  - `qwen_vlm/results/validation_loss.json`

## Troubleshooting

1. **CUDA Out of Memory**: Reduce batch size in config or use gradient accumulation
2. **NaN Losses**: Reduce learning rate or increase gradient clipping
3. **Import Errors**: Make sure all dependencies are installed and paths are correct
