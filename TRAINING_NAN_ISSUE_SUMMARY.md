# Training NaN Issue - Root Cause Analysis

## Problem
Training consistently produces NaN losses starting around step 4-8, regardless of:
- Learning rate (tried: 1e-4, 5e-5, 1e-5, 5e-6)
- Gradient clipping (tried: 1.0, 0.5, 0.3)
- Quantization type (tried: 4-bit, 8-bit)
- Gradient checkpointing (tried: enabled, disabled)

## Key Observations

1. **FP16 works but OOM**: When using FP16 (no quantization), loss values are valid (10.8, 10.5, etc.) but runs out of memory (~30GB needed)

2. **Quantization causes NaN**: Both 4-bit and 8-bit quantization consistently produce NaN losses very early in training

3. **Early onset**: NaN appears at step 4-8, suggesting it's not a training dynamics issue but a fundamental incompatibility

4. **Valid initial batches**: First 3-7 batches produce valid losses, then NaN appears

## Root Cause Hypothesis

The issue appears to be that **quantized models (4-bit/8-bit) are fundamentally incompatible with full fine-tuning** of LLaVA models. The quantization introduces numerical instability that causes:
- Gradient computation to produce NaN
- Model weights to become corrupted
- Loss to become NaN

## Solutions Tried

1. ✅ Reduced learning rate (1e-4 → 5e-6)
2. ✅ Tighter gradient clipping (1.0 → 0.3)
3. ✅ Disabled gradient checkpointing
4. ✅ Added label validation
5. ✅ Enhanced NaN detection
6. ✅ 8-bit quantization with stability settings
7. ❌ All still produce NaN

## Recommended Solutions

### Option 1: Use LoRA/PEFT (Parameter-Efficient Fine-Tuning)
- Train only small adapter layers instead of full model
- Much more stable with quantized models
- Lower memory requirements
- Requires installing `peft` library

### Option 2: Use FP16 with CPU Offloading
- Use FP16 for language model
- Offload vision encoder to CPU (it's frozen anyway)
- May reduce memory enough to fit

### Option 3: Use Smaller Model
- Try LLaVA-1.5-7B instead of LLaVA-NeXT-7B
- Or use a smaller variant if available

### Option 4: Use Gradient Checkpointing + FP16
- Enable gradient checkpointing to reduce memory
- Use FP16 instead of quantization
- May fit in memory with aggressive checkpointing

## Current Status

Training is currently failing with NaN losses. The checkpoints from the first training run (with NaN losses) may still contain some useful weights, but they're likely corrupted.

## Next Steps

1. Implement LoRA/PEFT fine-tuning (recommended)
2. Or try FP16 with vision encoder CPU offloading
3. Or accept the NaN losses and see if the model still learns something (not recommended)

