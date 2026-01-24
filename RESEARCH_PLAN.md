# Research Plan: Cross-Modal Video Summarization for Car Crash Videos
## Based on V2Xum-LLM Framework with LLaVA-NeXT

---

## 1. Research Overview

### 1.1 Objective
Adapt the V2Xum-LLM framework for cross-modal video summarization specifically for car crash videos using:
- **LLaVA-NeXT** (latest version) instead of LLaVA-1.5
- **Car Crash Dataset** (1500 videos with ground truth annotations)
- **5-second video segments** with every 5th frame sampling
- **Zero-shot evaluation** on pretrained models

### 1.2 Key Differences from Original Paper
| Aspect | Original V2Xum-LLM | Our Adaptation |
|--------|-------------------|----------------|
| Model | LLaVA-1.5-7B | LLaVA-NeXT |
| Dataset | Instruct-V2Xum (30K videos) | Car Crash Dataset (1500 videos) |
| Video Length | 40-940 seconds | 5 seconds |
| Frame Sampling | 1 FPS | Every 5th frame |
| Split | 25K/1K/4K | 70%/15%/15% |
| Evaluation | BLEU, METEOR, ROUGE, CIDEr, F1 | **NLI, BLEU** |
| Testing | Fine-tuned | **Zero-shot (pretrained)** |

---

## 2. Dataset Preparation

### 2.1 Dataset Structure
- **Videos**: 1500 MP4 files (currently in `/videos` folder)
- **Ground Truth**: `Car_Crash_Text_Dataset (3).xlsx` (Excel format)
- **Source**: CarCrashDataset from GitHub

### 2.2 Data Preprocessing Steps

#### Step 2.2.1: Video Processing
```python
# Pseudocode for video preprocessing
1. Extract 5-second segments from each video
2. Sample every 5th frame from each 5-second segment
3. For 5 seconds at 30fps: 150 frames → sample 30 frames
4. Store processed frames with temporal indices
```

#### Step 2.2.2: Ground Truth Processing
```python
# Pseudocode for ground truth extraction
1. Load Excel file: Car_Crash_Text_Dataset (3).xlsx
2. Extract video IDs and corresponding text summaries
3. Map video files to ground truth annotations
4. Create aligned video-text pairs
```

#### Step 2.2.3: Dataset Splitting
- **Training**: 70% (1050 videos)
- **Validation**: 15% (225 videos)
- **Testing**: 15% (225 videos) - **Zero-shot evaluation**

### 2.3 Data Format
```
Dataset Structure:
├── train/
│   ├── videos/ (1050 videos)
│   ├── frames/ (frame sequences per video)
│   └── annotations.jsonl
├── val/
│   ├── videos/ (225 videos)
│   ├── frames/
│   └── annotations.jsonl
└── test/
    ├── videos/ (225 videos)
    ├── frames/
    └── annotations.jsonl
```

---

## 3. Model Architecture

### 3.1 Base Model: LLaVA-NeXT
- **Repository**: https://github.com/LLaVA-VL/LLaVA-NeXT
- **Purpose**: Vision-language model for frame understanding
- **Usage**: 
  - Frame captioning (similar to original paper's LLaVA-1.5 usage)
  - Vision encoder for video frames

### 3.2 Framework Adaptation: V2Xum-LLaMA Style

#### 3.2.1 Components
1. **Vision Encoder**: CLIP ViT-L/14 (or LLaVA-NeXT's vision encoder)
2. **Language Decoder**: LLaMA/Vicuna (7B or 13B)
3. **Vision Adapter**: MLP for aligning visual features to text token space
4. **Temporal Prompts**: Frame-level timestamps in natural language format

#### 3.2.2 Temporal Prompt Mechanism
- Format: "00", "05", "10", "15", ... (representing frame positions)
- Interleaved with visual tokens: `{t1, v1, t2, v2, ..., tL, vL}`
- For 5-second videos with every 5th frame: ~30 frames → 30 temporal prompts

### 3.3 Task Types
1. **V2V (Video-to-Video)**: Select key frames from input video
2. **V2T (Video-to-Text)**: Generate textual summary
3. **V2VT (Video-to-Video&Text)**: Generate both video and text summaries simultaneously

---

## 4. Implementation Plan

### 4.1 Phase 1: Environment Setup (Week 1)

#### 4.1.1 GPU Access
- Verify GPU availability (NVIDIA A100/V100 or similar)
- Set up CUDA environment
- Install required libraries

#### 4.1.2 Repository Setup
```bash
# Clone LLaVA-NeXT
git clone https://github.com/LLaVA-VL/LLaVA-NeXT.git
cd LLaVA-NeXT

# Install dependencies
pip install -r requirements.txt
```

#### 4.1.3 Dependencies
- PyTorch (with CUDA support)
- Transformers
- CLIP
- pandas (for Excel processing)
- opencv-python (for video processing)
- Pillow
- Other dependencies from LLaVA-NeXT

### 4.2 Phase 2: Data Processing Pipeline (Week 1-2)

#### 4.2.1 Video Processing Script
```python
# video_processor.py
- Extract 5-second segments
- Sample every 5th frame
- Save frames with metadata
- Generate frame indices
```

#### 4.2.2 Ground Truth Parser
```python
# ground_truth_parser.py
- Read Excel file
- Extract video-text pairs
- Create JSON/JSONL format
- Map to video files
```

#### 4.2.3 Dataset Splitter
```python
# dataset_splitter.py
- Random split: 70/15/15
- Ensure no data leakage
- Create train/val/test directories
- Generate split metadata
```

### 4.3 Phase 3: Model Integration (Week 2-3)

#### 4.3.1 LLaVA-NeXT Integration
- Load pretrained LLaVA-NeXT model
- Extract vision encoder
- Adapt for video frame processing
- Test frame captioning capability

#### 4.3.2 Temporal Prompt Implementation
```python
# temporal_prompts.py
- Generate temporal tokens for each frame
- Format: "00", "05", "10", etc.
- Interleave with visual tokens
- Create input sequence
```

#### 4.3.3 Instruction Tuning Setup
- Define task instructions:
  - "Please generate a video summarization for this car crash video."
  - "Please generate a text summarization for this car crash video."
  - "Please generate both video and text summarization for this car crash video."

### 4.4 Phase 4: Training Pipeline (Week 3-4)

#### 4.4.1 Training Configuration
- **Model**: V2Xum-LLaMA style with LLaVA-NeXT
- **Batch Size**: Adjust based on GPU memory
- **Learning Rate**: 1e-4 (as in original paper)
- **Epochs**: 5 (or until convergence)
- **Optimizer**: AdamW
- **Loss Function**: Cross-entropy for text generation

#### 4.4.2 Training Loop
```python
# training.py
- Load training data
- Process videos → frames → captions
- Generate temporal prompts
- Forward pass through model
- Compute loss
- Backward pass
- Save checkpoints
```

#### 4.4.3 Loss Tracking
- **Training Loss**: Save after each epoch
- **Validation Loss**: Compute on validation set
- **Metrics**: Track BLEU, NLI during training
- **Checkpoints**: Save model weights periodically

### 4.5 Phase 5: Zero-Shot Evaluation (Week 4-5)

#### 4.5.1 Pretrained Model Testing
- Load pretrained LLaVA-NeXT (without fine-tuning)
- Test on test set (225 videos)
- Generate predictions for:
  - V2V summarization
  - V2T summarization
  - V2VT summarization

#### 4.5.2 Evaluation Metrics

##### BLEU Score
```python
# bleu_evaluator.py
- Compare generated text summaries with ground truth
- Compute BLEU-1, BLEU-2, BLEU-3, BLEU-4
- Report average BLEU score
```

##### NLI (Natural Language Inference)
```python
# nli_evaluator.py
- Use pretrained NLI model (e.g., RoBERTa-based)
- Check if generated summary entails/contradicts ground truth
- Compute entailment scores
- Report accuracy/precision/recall
```

#### 4.5.3 Evaluation Script
```python
# evaluate.py
- Load test set
- Run inference on pretrained model
- Compute BLEU scores
- Compute NLI scores
- Generate evaluation report
```

---

## 5. File Structure

```
project/
├── data/
│   ├── videos/ (1500 MP4 files)
│   ├── processed/
│   │   ├── train/
│   │   ├── val/
│   │   └── test/
│   └── ground_truth/
│       └── Car_Crash_Text_Dataset (3).xlsx
├── src/
│   ├── data_processing/
│   │   ├── video_processor.py
│   │   ├── ground_truth_parser.py
│   │   └── dataset_splitter.py
│   ├── models/
│   │   ├── llava_next_integration.py
│   │   ├── temporal_prompts.py
│   │   └── v2xum_llama.py
│   ├── training/
│   │   ├── train.py
│   │   ├── trainer.py
│   │   └── loss_tracker.py
│   ├── evaluation/
│   │   ├── evaluate.py
│   │   ├── bleu_evaluator.py
│   │   └── nli_evaluator.py
│   └── utils/
│       ├── config.py
│       └── helpers.py
├── checkpoints/
│   ├── training_loss.json
│   ├── validation_loss.json
│   └── model_weights/
├── results/
│   ├── zero_shot_evaluation/
│   └── metrics/
├── notebooks/
│   └── data_exploration.ipynb
├── requirements.txt
├── README.md
└── RESEARCH_PLAN.md (this file)
```

---

## 6. Evaluation Metrics Details

### 6.1 BLEU Score
- **Purpose**: Measure n-gram overlap between generated and reference summaries
- **Implementation**: Use `nltk.translate.bleu_score` or `sacrebleu`
- **Metrics**: BLEU-1, BLEU-2, BLEU-3, BLEU-4
- **Report**: Average BLEU score across all test samples

### 6.2 NLI (Natural Language Inference)
- **Purpose**: Assess semantic similarity and logical consistency
- **Model**: Use pretrained NLI model (e.g., `roberta-large-mnli` from HuggingFace)
- **Task**: Determine if generated summary:
  - **Entails** the ground truth (correct)
  - **Contradicts** the ground truth (incorrect)
  - **Neutral** (unrelated)
- **Metrics**: 
  - Entailment Accuracy
  - Precision/Recall for entailment class
  - F1 Score

---

## 7. Loss Tracking

### 7.1 Training Loss
- **Format**: JSON file with epoch-wise loss
```json
{
  "epoch_1": {"loss": 2.345, "bleu": 0.12, "nli_accuracy": 0.45},
  "epoch_2": {"loss": 1.987, "bleu": 0.18, "nli_accuracy": 0.52},
  ...
}
```

### 7.2 Validation Loss
- **Format**: JSON file with validation metrics per epoch
```json
{
  "epoch_1": {
    "val_loss": 2.123,
    "val_bleu": 0.15,
    "val_nli_accuracy": 0.48
  },
  ...
}
```

### 7.3 Visualization
- Plot training/validation loss curves
- Plot BLEU scores over epochs
- Plot NLI accuracy over epochs

---

## 8. Timeline

| Week | Tasks | Deliverables |
|------|-------|--------------|
| **Week 1** | Environment setup, data exploration | Setup complete, data structure understood |
| **Week 2** | Data processing, dataset splitting | Processed dataset ready |
| **Week 3** | Model integration, temporal prompts | Model architecture ready |
| **Week 4** | Training pipeline, loss tracking | Trained model, loss logs |
| **Week 5** | Zero-shot evaluation, metrics computation | Evaluation results, final report |

---

## 9. Key Challenges & Solutions

### 9.1 Challenge: 5-second video segments
- **Solution**: Extract fixed 5-second windows, handle edge cases

### 9.2 Challenge: Every 5th frame sampling
- **Solution**: Use OpenCV to extract frames at specific intervals

### 9.3 Challenge: Zero-shot evaluation
- **Solution**: Use pretrained LLaVA-NeXT without fine-tuning, test generalization

### 9.4 Challenge: NLI metric implementation
- **Solution**: Use HuggingFace transformers with pretrained NLI models

### 9.5 Challenge: Excel ground truth parsing
- **Solution**: Use pandas to read Excel, map to video files correctly

---

## 10. Expected Outcomes

1. **Processed Dataset**: 1500 videos split into 70/15/15 with frame sequences
2. **Model Integration**: LLaVA-NeXT adapted for video summarization
3. **Training Results**: Loss curves, training/validation metrics
4. **Zero-Shot Evaluation**: BLEU and NLI scores on test set
5. **Research Report**: Comparison with original V2Xum-LLM approach

---

## 11. Next Steps

1. ✅ Read research papers (DONE)
2. ⏳ Set up GPU environment
3. ⏳ Clone LLaVA-NeXT repository
4. ⏳ Process video dataset (5-second segments, every 5th frame)
5. ⏳ Parse Excel ground truth file
6. ⏳ Create train/val/test splits
7. ⏳ Integrate LLaVA-NeXT model
8. ⏳ Implement temporal prompts
9. ⏳ Set up training pipeline
10. ⏳ Implement BLEU and NLI evaluators
11. ⏳ Run zero-shot evaluation
12. ⏳ Generate final report

---

## 12. References

1. **V2Xum-LLM Paper**: "V2Xum-LLM: Cross-Modal Video Summarization with Temporal Prompt Instruction Tuning" (arXiv:2404.12353v1)
2. **LLaVA-NeXT**: https://github.com/LLaVA-VL/LLaVA-NeXT
3. **Car Crash Dataset**: https://github.com/Cogito2012/CarCrashDataset
4. **VideoXum**: Original cross-modal video summarization dataset paper

---

## 13. Notes

- **Zero-shot evaluation** means testing the pretrained model without any fine-tuning on our dataset
- **Every 5th frame** for 5-second videos: At 30fps, 5 seconds = 150 frames → sample 30 frames
- **NLI evaluation** provides semantic understanding beyond n-gram matching
- **Loss tracking** helps monitor training progress and detect overfitting

---

*Last Updated: [Current Date]*
*Status: Planning Phase*

