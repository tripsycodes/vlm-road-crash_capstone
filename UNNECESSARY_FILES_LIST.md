# Unnecessary Files and Folders - Cleanup List

Based on the entire chat history and codebase analysis, here are files and folders that are **NOT IMPORTANT** and can be safely removed:

## 🗑️ **LOG FILES** (28 files - ~500MB+)
**All training/evaluation log files - temporary debugging output:**
- `training_run.log`
- `training_run_debug.log`
- `training_run_lora.log`
- `training_run_lora_final.log`
- `training_run_final.log`
- `training_run_fp16.log`
- `training_run_v3.log`
- `training_run_background.log`
- `evaluation_complete_final.log`
- `evaluation_complete.log`
- `evaluation_final_working.log`
- `evaluation_working.log`
- `evaluation_test_quick.log`
- `evaluation_final.log`
- `evaluation_success.log`
- `evaluation_final_run.log`
- `evaluation_test.log`
- `evaluation_gpu2_dtype_fixed.log`
- `evaluation_gpu2_final_fixed.log`
- `evaluation_gpu2_v3.log`
- `evaluation_gpu2_final.log`
- `evaluation_gpu2_fixed.log`
- `evaluation_gpu2.log`
- `qwen_training_background.log`
- `qwen_training_gpu2_4bit.log`
- `qwen_training_gpu2.log`
- `qwen_training_gpu3_fixed.log`
- `qwen_training_gpu3.log`

**Action:** Delete all `.log` files - they're just temporary debugging output.

---

## 📝 **TEMPORARY INVESTIGATION DOCUMENTS** (2 files)
**These were created during debugging and are no longer needed:**
- `TRAINING_INVESTIGATION_SUMMARY.md` - Investigation notes from training issues
- `TRAINING_NAN_ISSUE_SUMMARY.md` - Root cause analysis of NaN issues (already resolved)

**Action:** Delete - issues are resolved, information is in git history if needed.

---

## 🔧 **UTILITY SCRIPTS** (2 files - one-time use)
**Created for debugging, not needed for production:**
- `scripts/check_training_progress.py` - One-time utility to check training progress
- `scripts/verify_checkpoint.py` - One-time utility to verify checkpoint loading

**Action:** Delete or move to `scripts/utils/` if you want to keep them for future debugging.

---

## 📊 **PLANNING/DOCUMENTATION FILES** (Some may be outdated)
**Review these - some might be outdated planning docs:**
- `IMPLEMENTATION_CHECKLIST.md` - If implementation is complete, this can be archived
- `NEXT_STEPS.md` - Planning document, may be outdated
- `RESEARCH_PLAN.md` - Planning document, may be outdated
- `CODEBASE_SUMMARY.md` - Might be outdated if codebase changed
- `CONTRIBUTIONS_SUMMARY.md` - Review if still relevant
- `UNIQUE_CONTRIBUTIONS.md` - Review if still relevant

**Action:** Review and delete if outdated, or move to `docs/archive/` folder.

---

## 🐍 **VIRTUAL ENVIRONMENT** (6.3 GB)
**Should NEVER be committed to git:**
- `venv/` - Entire virtual environment folder (6.3 GB)

**Action:** 
- Delete from repository
- Add to `.gitignore` if not already there
- Users should create their own venv using `requirements.txt`

---

## 📚 **RESEARCH PAPERS** (PDFs - not code)
**These are reference materials, not part of the codebase:**
- `2303.12060v3 (1).pdf`
- `2404.12353v1.pdf`
- `Qiu_MMSum_A_Dataset_for_Multimodal_Summarization_and_Thumbnail_Generation_of_CVPR_2024_paper.pdf`

**Action:** Move to `docs/papers/` or delete - these are reference materials, not code.

---

## 📋 **DATASET FILES** (May be needed, but check)
**Review if these are needed in the repo:**
- `Car_Crash_Text_Dataset (3).xlsx` - Dataset file
- `Crash-1500.zip` - Dataset archive

**Action:** 
- If dataset is stored elsewhere, delete these
- If needed for reproducibility, keep but document in README
- Consider moving to `data/raw/` folder

---

## 🔄 **MONITOR SCRIPTS** (Temporary)
**Created for monitoring training, may not be needed:**
- `monitor_training.sh` - Temporary monitoring script
- `monitor_qwen_training.sh` - Temporary monitoring script

**Action:** Delete if not planning to use again, or move to `scripts/utils/`.

---

## 📦 **LLaVA-NeXT REPOSITORY** (132 MB)
**This is the original LLaVA-NeXT repository:**
- `LLaVA-NeXT/` - Entire folder (132 MB)

**Action:** 
- **KEEP IF:** You're using code from it or need it for reference
- **DELETE IF:** You're only using your wrapper (`src/models/llava_next_wrapper.py`) and don't need the original repo
- **RECOMMENDATION:** If you're using HuggingFace models, you likely don't need this entire repo

---

## ✅ **FILES TO KEEP (IMPORTANT)**
These are **ESSENTIAL** and should **NOT** be deleted:

### Core Code:
- `src/` - All source code
- `scripts/01_process_data.py`
- `scripts/02_evaluate_zero_shot.py`
- `scripts/03_finetune.py` ⭐
- `scripts/04_evaluate_finetuned.py`
- `scripts/05_compare_results.py`
- `qwen_vlm/` - Entire Qwen-VL implementation ⭐

### Configuration:
- `config/config.yaml` ⭐
- `qwen_vlm/config/config_qwen.yaml` ⭐
- `requirements.txt` ⭐

### Results (Training Output):
- `results/checkpoints/` - All checkpoints ⭐
- `results/training_loss.json` ⭐
- `results/validation_loss.json` ⭐
- `results/metrics/` - Evaluation metrics
- `results/finetuned/` - Fine-tuned model outputs
- `results/zero_shot/` - Zero-shot results

### Documentation:
- `README.md` ⭐
- `QUICK_START.md`
- `SETUP_AND_RUN.md`
- `EVALUATION_METRICS_EXPLAINED.md`
- `qwen_vlm/README.md`

### Setup Scripts:
- `setup_env.sh`
- `run_pipeline.sh`

### Data:
- `data/` - Processed data
- `videos/` - Video files (if needed)

---

## 📊 **SUMMARY STATISTICS**

| Category | Count | Size | Action |
|----------|-------|------|--------|
| Log files | 28 | ~500MB+ | **DELETE** |
| Investigation docs | 2 | ~50KB | **DELETE** |
| Utility scripts | 2 | ~10KB | **DELETE/MOVE** |
| Virtual environment | 1 | **6.3 GB** | **DELETE** |
| PDF papers | 3 | ~10MB | **MOVE/DELETE** |
| LLaVA-NeXT repo | 1 | 132 MB | **REVIEW** |
| **TOTAL SAVINGS** | - | **~7 GB+** | - |

---

## 🚀 **RECOMMENDED CLEANUP COMMANDS**

```bash
# Delete all log files
find . -name "*.log" -type f -delete

# Delete investigation summaries
rm TRAINING_INVESTIGATION_SUMMARY.md TRAINING_NAN_ISSUE_SUMMARY.md

# Delete utility scripts (or move to utils folder)
rm scripts/check_training_progress.py scripts/verify_checkpoint.py

# Delete virtual environment (users should create their own)
rm -rf venv/

# Delete monitor scripts
rm monitor_training.sh monitor_qwen_training.sh

# Move PDFs to docs folder (optional)
mkdir -p docs/papers
mv *.pdf docs/papers/ 2>/dev/null

# Review and potentially delete LLaVA-NeXT if not needed
# rm -rf LLaVA-NeXT/
```

---

## ⚠️ **IMPORTANT NOTES**

1. **Backup before deleting:** Make sure you have a backup or git commit before bulk deletion
2. **Check .gitignore:** Ensure `venv/`, `*.log`, and other temporary files are in `.gitignore`
3. **Dataset files:** Review if `Car_Crash_Text_Dataset (3).xlsx` and `Crash-1500.zip` are needed
4. **LLaVA-NeXT folder:** Only delete if you're 100% sure you don't need it
5. **Results folder:** **NEVER DELETE** `results/checkpoints/` - these are your trained models!

---

**Last Updated:** Based on chat history analysis
**Total Space to Reclaim:** ~7 GB+
