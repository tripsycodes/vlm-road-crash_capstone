# Car Crash Video Summarization with LLaVA-NeXT

Cross-modal video summarization for car crash videos using LLaVA-NeXT with sparse temporal sampling and zero-shot evaluation.

## 🎯 Project Overview

This project implements an efficient cross-modal video summarization system for car crash videos, featuring:
- **Sparse frame sampling** (every 5th frame) for efficiency
- **Zero-shot evaluation** on pretrained models
- **Semantic evaluation** using NLI (Natural Language Inference)
- **5-second video segments** for real-time processing

## 📁 Project Structure

```
.
├── config/
│   └── config.yaml              # Configuration file
├── data/
│   └── processed/               # Processed dataset
├── results/
│   ├── checkpoints/             # Model checkpoints
│   ├── metrics/                 # Evaluation metrics
│   └── zero_shot/               # Zero-shot evaluation results
├── scripts/
│   ├── 01_process_data.py       # Data processing pipeline
│   └── 02_evaluate_zero_shot.py # Zero-shot evaluation
├── src/
│   ├── data_processing/         # Video processing, ground truth parsing
│   ├── models/                  # LLaVA-NeXT integration, temporal prompts
│   ├── training/                # Training pipeline, loss tracking
│   ├── evaluation/              # BLEU and NLI evaluators
│   └── utils/                   # Configuration utilities
├── requirements.txt
└── README.md
```

## 🚀 Quick Start

### 1. Installation

```bash
# Clone repository (if needed)
cd /home/vaneet_2221cs15/vlmvideos/Vaneet_mam_vlm

# Install dependencies
pip install -r requirements.txt

# Install LLaVA-NeXT (if available)
# git clone https://github.com/LLaVA-VL/LLaVA-NeXT.git
# cd LLaVA-NeXT && pip install -e .
```

### 2. Data Processing

Process videos and prepare dataset:

```bash
python scripts/01_process_data.py
```

This will:
- Extract frames from videos (every 5th frame, 5-second segments)
- Parse ground truth from Excel file
- Split dataset into train/val/test (70/15/15)
- Save processed data and annotations

### 3. Zero-Shot Evaluation

Run zero-shot evaluation on pretrained model:

```bash
python scripts/02_evaluate_zero_shot.py
```

This will:
- Load pretrained LLaVA-NeXT model
- Generate summaries for test videos
- Compute BLEU and NLI scores
- Save results to `results/zero_shot/`

## 📊 Configuration

Edit `config/config.yaml` to customize:
- Dataset paths
- Model settings
- Training parameters
- Evaluation metrics

## 🔧 Key Components

### Data Processing
- **VideoProcessor**: Extracts frames with sparse sampling
- **GroundTruthParser**: Parses Excel annotations
- **DatasetSplitter**: Creates train/val/test splits

### Models
- **LLaVANeXTWrapper**: Wrapper for LLaVA-NeXT model
- **TemporalPromptGenerator**: Generates temporal prompts for frames

### Evaluation
- **BLEUEvaluator**: Computes BLEU-1 to BLEU-4 scores
- **NLIEvaluator**: Computes semantic similarity using NLI

### Training
- **LossTracker**: Tracks and saves training/validation losses

## 📈 Results

Results are saved in `results/` directory:
- `results/zero_shot/metrics.json`: Evaluation metrics
- `results/zero_shot/detailed_results.json`: Per-video results
- `results/training_loss.json`: Training loss history
- `results/validation_loss.json`: Validation loss history

## 🎓 Research Contributions

This work addresses several gaps in existing video summarization research:
1. **Domain-specific application**: Car crash videos (safety-critical)
2. **Efficiency**: Sparse frame sampling (80% reduction)
3. **Zero-shot evaluation**: Tests pretrained model generalization
4. **Semantic evaluation**: NLI metric for semantic correctness
5. **Short video segments**: 5-second segments for real-time processing

## 📝 Citation

If you use this code, please cite:

```bibtex
@article{car_crash_video_summarization,
  title={Efficient Zero-Shot Cross-Modal Video Summarization for Safety-Critical Domains},
  author={Your Name},
  journal={Conference Name},
  year={2024}
}
```

## 📄 License

[Add your license here]

## 🤝 Contributing

[Add contribution guidelines]

## 📧 Contact

[Add contact information]

