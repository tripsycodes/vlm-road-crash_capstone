# Implementation Checklist

## Quick Start Guide

### Phase 1: Setup (Priority: HIGH)
- [ ] **GPU Access Verification**
  ```bash
  nvidia-smi  # Check GPU availability
  ```
- [ ] **Clone LLaVA-NeXT Repository**
  ```bash
  git clone https://github.com/LLaVA-VL/LLaVA-NeXT.git
  cd LLaVA-NeXT
  pip install -e .
  ```
- [ ] **Install Dependencies**
  ```bash
  pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
  pip install transformers datasets accelerate
  pip install opencv-python pandas openpyxl nltk sacrebleu
  pip install sentence-transformers  # For NLI evaluation
  ```

### Phase 2: Data Processing (Priority: HIGH)
- [ ] **Extract Video Information**
  - Check video durations
  - Verify frame rates
  - List all video files
  
- [ ] **Create Video Processing Script**
  - Extract 5-second segments
  - Sample every 5th frame
  - Save frames with metadata
  
- [ ] **Parse Excel Ground Truth**
  - Read `Car_Crash_Text_Dataset (3).xlsx`
  - Extract video-text mappings
  - Convert to JSON/JSONL format
  
- [ ] **Create Dataset Split**
  - 70% train (1050 videos)
  - 15% validation (225 videos)
  - 15% test (225 videos)
  - Ensure no overlap

### Phase 3: Model Setup (Priority: MEDIUM)
- [ ] **Load LLaVA-NeXT Pretrained Model**
  - Download model weights
  - Test frame captioning
  - Verify GPU compatibility
  
- [ ] **Implement Temporal Prompts**
  - Generate frame-level timestamps
  - Format: "00", "05", "10", etc.
  - Interleave with visual tokens
  
- [ ] **Create Instruction Templates**
  - V2V: "Generate video summarization"
  - V2T: "Generate text summarization"
  - V2VT: "Generate both video and text summarization"

### Phase 4: Training (Priority: MEDIUM)
- [ ] **Set Up Training Script**
  - Data loader
  - Model forward pass
  - Loss computation
  - Optimizer setup
  
- [ ] **Implement Loss Tracking**
  - Training loss per epoch
  - Validation loss per epoch
  - Save to JSON files
  
- [ ] **Training Configuration**
  - Learning rate: 1e-4
  - Batch size: Adjust for GPU
  - Epochs: 5
  - Checkpoint saving

### Phase 5: Evaluation (Priority: HIGH)
- [ ] **BLEU Score Implementation**
  - Install sacrebleu or nltk
  - Compute BLEU-1 to BLEU-4
  - Average across test set
  
- [ ] **NLI Evaluation Setup**
  - Load pretrained NLI model (RoBERTa-large-MNLI)
  - Implement entailment checking
  - Compute accuracy/precision/recall
  
- [ ] **Zero-Shot Testing**
  - Load pretrained LLaVA-NeXT (no fine-tuning)
  - Run inference on test set
  - Generate predictions
  - Compute metrics

### Phase 6: Results & Documentation (Priority: LOW)
- [ ] **Generate Loss Curves**
  - Plot training/validation loss
  - Plot BLEU scores over epochs
  - Plot NLI accuracy
  
- [ ] **Create Evaluation Report**
  - Zero-shot BLEU scores
  - Zero-shot NLI scores
  - Comparison with baseline
  - Analysis and conclusions

---

## File Structure to Create

```
project/
├── scripts/
│   ├── 01_process_videos.py
│   ├── 02_parse_ground_truth.py
│   ├── 03_split_dataset.py
│   ├── 04_train_model.py
│   └── 05_evaluate.py
├── src/
│   ├── data/
│   │   ├── video_processor.py
│   │   ├── ground_truth_parser.py
│   │   └── dataset_splitter.py
│   ├── models/
│   │   ├── llava_next_wrapper.py
│   │   └── temporal_prompts.py
│   ├── training/
│   │   ├── trainer.py
│   │   └── loss_tracker.py
│   └── evaluation/
│       ├── bleu_evaluator.py
│       └── nli_evaluator.py
├── config/
│   └── config.yaml
└── results/
    ├── training_loss.json
    ├── validation_loss.json
    └── zero_shot_metrics.json
```

---

## Key Code Snippets to Implement

### 1. Video Processing
```python
import cv2
def extract_frames(video_path, segment_duration=5, frame_interval=5):
    # Extract 5-second segment
    # Sample every 5th frame
    # Return frame list with timestamps
    pass
```

### 2. Temporal Prompts
```python
def generate_temporal_prompts(num_frames):
    # Generate "00", "05", "10", ... format
    # Return list of temporal tokens
    pass
```

### 3. Loss Tracking
```python
import json
def save_loss(epoch, train_loss, val_loss, metrics):
    # Save to JSON file
    # Format: {"epoch_1": {"loss": ..., "bleu": ..., "nli": ...}}
    pass
```

### 4. BLEU Evaluation
```python
from sacrebleu import BLEU
def compute_bleu(predictions, references):
    # Compute BLEU-1 to BLEU-4
    # Return average score
    pass
```

### 5. NLI Evaluation
```python
from transformers import AutoModelForSequenceClassification, AutoTokenizer
def compute_nli(predictions, references):
    # Load NLI model
    # Check entailment
    # Return accuracy/precision/recall
    pass
```

---

## Testing Checklist

- [ ] Video processing produces correct number of frames
- [ ] Ground truth parsing matches videos correctly
- [ ] Dataset split has no overlap
- [ ] Model loads successfully
- [ ] Temporal prompts format correctly
- [ ] Training loop runs without errors
- [ ] Loss decreases over epochs
- [ ] Evaluation metrics compute correctly
- [ ] Zero-shot evaluation runs on test set

---

## Common Issues & Solutions

1. **GPU Memory Error**
   - Reduce batch size
   - Use gradient accumulation
   - Process fewer frames per video

2. **Video Format Issues**
   - Check codec compatibility
   - Convert videos if needed
   - Verify frame extraction

3. **Excel Parsing Errors**
   - Check file encoding
   - Verify column names
   - Handle missing values

4. **Model Loading Issues**
   - Check model path
   - Verify CUDA availability
   - Ensure correct model version

---

*Use this checklist to track your progress!*

