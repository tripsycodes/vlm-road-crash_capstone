# Evaluation Metrics Explained
## Understanding BLEU and NLI Scores

---

## 📊 BLEU Scores Explained

### What is BLEU?

**BLEU (Bilingual Evaluation Understudy)** is a metric that measures how similar a generated text is to a reference text by comparing n-grams (sequences of n words).

### BLEU Score Components

#### 1. **BLEU-1** (Unigram Precision)
- **What it measures**: How many individual words from the reference appear in the prediction
- **Range**: 0.0 to 1.0 (higher is better)
- **Example**:
  - Reference: "A car crashed into a tree"
  - Prediction: "A vehicle hit a tree"
  - BLEU-1 checks: "A", "car"/"vehicle", "crashed"/"hit", "a", "tree"
  - **Interpretation**: Measures word-level overlap

#### 2. **BLEU-2** (Bigram Precision)
- **What it measures**: How many pairs of consecutive words match
- **Range**: 0.0 to 1.0 (higher is better)
- **Example**:
  - Reference: "A car crashed into a tree"
  - Prediction: "A car hit a tree"
  - BLEU-2 checks: "A car", "car crashed"/"car hit", "crashed into"/"hit a", etc.
  - **Interpretation**: Measures phrase-level similarity

#### 3. **BLEU-3** (Trigram Precision)
- **What it measures**: How many triplets of consecutive words match
- **Range**: 0.0 to 1.0 (higher is better)
- **Example**:
  - Reference: "A car crashed into a tree"
  - Prediction: "A car crashed into a wall"
  - BLEU-3 checks: "A car crashed", "car crashed into", "crashed into a", etc.
  - **Interpretation**: Measures longer phrase similarity

#### 4. **BLEU-4** (4-gram Precision)
- **What it measures**: How many sequences of 4 consecutive words match
- **Range**: 0.0 to 1.0 (higher is better)
- **Example**:
  - Reference: "A car crashed into a tree"
  - Prediction: "A car crashed into a tree"
  - BLEU-4 checks: "A car crashed into", "car crashed into a", "crashed into a tree"
  - **Interpretation**: Measures sentence-level similarity (most commonly reported)

#### 5. **BLEU-Corpus** (Corpus-level BLEU)
- **What it measures**: Average BLEU score across all test samples
- **Range**: 0.0 to 1.0 (higher is better)
- **Interpretation**: Overall performance across the entire test set

### Understanding BLEU Score Values

| Score Range | Interpretation |
|-------------|----------------|
| **0.0 - 0.3** | Poor match - very different from reference |
| **0.3 - 0.5** | Moderate match - some similarity |
| **0.5 - 0.7** | Good match - substantial overlap |
| **0.7 - 0.9** | Very good match - high similarity |
| **0.9 - 1.0** | Excellent match - nearly identical |

### Example from Your Output

```
BLEU Scores:
  bleu_1: 0.4523    # 45% of individual words match
  bleu_2: 0.3421    # 34% of word pairs match
  bleu_3: 0.2890    # 29% of word triplets match
  bleu_4: 0.2456    # 25% of 4-word sequences match
  bleu_corpus: 0.3123  # Average BLEU across all samples
```

**Interpretation**: 
- Moderate performance (0.3-0.5 range)
- Word-level matching (BLEU-1) is better than phrase-level (BLEU-4)
- This suggests the model captures individual words but struggles with exact phrase matching

### Why Multiple BLEU Scores?

- **BLEU-1**: Catches if important words are present
- **BLEU-2**: Checks if common phrases are used
- **BLEU-3**: Verifies longer phrase structures
- **BLEU-4**: Most strict - requires exact sentence structure
- **Higher n-grams = Stricter evaluation**

---

## 🧠 NLI Scores Explained

### What is NLI?

**NLI (Natural Language Inference)** evaluates whether a generated summary is **semantically consistent** with the ground truth. It goes beyond word matching to check logical relationships.

### NLI Score Components

#### 1. **Entailment Accuracy**
- **What it measures**: Percentage of predictions that are semantically entailed by (logically consistent with) the reference
- **Range**: 0.0 to 1.0 (higher is better)
- **Example**:
  - Reference: "A car crashed into a tree"
  - Prediction: "A vehicle hit a tree" → **ENTAILMENT** ✅ (semantically correct)
  - Prediction: "A car drove safely" → **CONTRADICTION** ❌ (opposite meaning)
- **Interpretation**: Higher = more semantically correct summaries

#### 2. **Contradiction Rate**
- **What it measures**: Percentage of predictions that contradict the reference
- **Range**: 0.0 to 1.0 (lower is better)
- **Example**:
  - Reference: "A car crashed into a tree"
  - Prediction: "No accident occurred" → **CONTRADICTION** ❌
- **Interpretation**: Lower = fewer incorrect summaries

#### 3. **Neutral Rate**
- **What it measures**: Percentage of predictions that are unrelated to the reference
- **Range**: 0.0 to 1.0 (lower is better)
- **Example**:
  - Reference: "A car crashed into a tree"
  - Prediction: "The weather was sunny" → **NEUTRAL** ⚠️ (unrelated)
- **Interpretation**: Lower = more relevant summaries

#### 4. **Average Entailment Probability**
- **What it measures**: Average confidence that predictions are entailed by references
- **Range**: 0.0 to 1.0 (higher is better)
- **Interpretation**: Higher = model is more confident in semantic correctness

### Understanding NLI Score Values

#### Entailment Accuracy
| Score Range | Interpretation |
|-------------|----------------|
| **0.0 - 0.5** | Poor - many contradictions or neutral statements |
| **0.5 - 0.7** | Moderate - some semantic consistency |
| **0.7 - 0.85** | Good - mostly semantically correct |
| **0.85 - 1.0** | Excellent - highly semantically consistent |

#### Contradiction Rate
| Score Range | Interpretation |
|-------------|----------------|
| **0.0 - 0.1** | Excellent - very few contradictions |
| **0.1 - 0.2** | Good - some contradictions |
| **0.2 - 0.3** | Moderate - noticeable contradictions |
| **> 0.3** | Poor - many contradictions |

### Example from Your Output

```
NLI Scores:
  entailment_accuracy: 0.7000      # 70% of summaries are semantically correct
  contradiction_rate: 0.1000        # 10% contradict the reference
  neutral_rate: 0.2000              # 20% are unrelated
  avg_entailment_prob: 0.7234       # 72% average confidence in correctness
  total_samples: 10
```

**Interpretation**:
- **Good semantic performance** (70% entailment accuracy)
- **Low contradiction rate** (10% - acceptable)
- **Some neutral cases** (20% - could be improved)
- **High confidence** (72% average probability)

---

## 🔄 BLEU vs. NLI: Key Differences

### BLEU (Surface-Level Matching)
- ✅ **Strengths**: 
  - Measures exact word/phrase overlap
  - Fast to compute
  - Standard in NLP
- ❌ **Limitations**:
  - Doesn't understand synonyms ("car" vs "vehicle")
  - Doesn't check semantic correctness
  - Can miss paraphrases

### NLI (Semantic Understanding)
- ✅ **Strengths**:
  - Understands semantic relationships
  - Catches synonyms and paraphrases
  - Verifies logical consistency
- ❌ **Limitations**:
  - Slower to compute
  - Requires pretrained NLI model
  - May be too lenient sometimes

### Why Use Both?

| Scenario | BLEU | NLI |
|----------|------|-----|
| **Exact phrase match** | ✅ High | ✅ High |
| **Paraphrase** | ❌ Low | ✅ High |
| **Synonym usage** | ❌ Low | ✅ High |
| **Contradiction** | ⚠️ May miss | ✅ Catches |
| **Unrelated text** | ⚠️ May miss | ✅ Catches |

**Example**:
- Reference: "A car crashed into a tree"
- Prediction: "A vehicle hit a tree"
  - **BLEU-4**: ~0.3 (low - different words)
  - **NLI**: 0.9 (high - semantically correct)

---

## 📈 Interpreting Your Results

### Your Example Output

```
BLEU Scores:
  bleu_1: 0.4523    → Moderate word-level match
  bleu_2: 0.3421    → Moderate phrase-level match
  bleu_3: 0.2890    → Lower longer phrase match
  bleu_4: 0.2456    → Lower sentence-level match
  bleu_corpus: 0.3123 → Overall moderate performance

NLI Scores:
  entailment_accuracy: 0.7000      → Good semantic correctness
  contradiction_rate: 0.1000       → Low contradictions (good!)
  neutral_rate: 0.2000             → Some unrelated summaries
  avg_entailment_prob: 0.7234      → High confidence
```

### What This Means

1. **BLEU Analysis**:
   - Model captures **individual words** (BLEU-1: 0.45)
   - Struggles with **exact phrase matching** (BLEU-4: 0.25)
   - May be using **synonyms or paraphrases**

2. **NLI Analysis**:
   - **70% semantically correct** - Good!
   - **Only 10% contradictions** - Acceptable
   - **20% neutral** - Could improve relevance

3. **Overall Assessment**:
   - ✅ **Semantically good** (NLI: 0.70)
   - ⚠️ **Surface-level moderate** (BLEU: 0.31)
   - **Conclusion**: Model understands meaning but uses different wording

### Improving Scores

#### To Improve BLEU:
- Use more exact phrases from reference
- Match word order better
- Use same terminology

#### To Improve NLI:
- Reduce contradictions (focus on accuracy)
- Reduce neutral cases (improve relevance)
- Increase semantic consistency

---

## 🎯 Best Practices

### For Research Papers

1. **Report Both Metrics**:
   - BLEU shows surface-level similarity
   - NLI shows semantic correctness

2. **Focus on NLI for Safety-Critical Domains**:
   - Car crash summaries must be **semantically correct**
   - BLEU can miss important semantic errors

3. **Compare with Baselines**:
   - Show improvement over existing methods
   - Highlight zero-shot performance

### For Your Research

**Your Unique Contribution**: Using NLI for video summarization evaluation
- Most papers only use BLEU
- NLI is better for safety-critical domains
- Shows semantic understanding beyond word matching

---

## 📚 Additional Resources

- **BLEU Paper**: "BLEU: a Method for Automatic Evaluation of Machine Translation" (Papineni et al., 2002)
- **NLI Models**: RoBERTa-large-MNLI (used in your code)
- **MNLI Dataset**: Multi-Genre Natural Language Inference

---

## ✅ Summary

| Metric | What It Measures | Good Score | Your Score | Status |
|--------|------------------|------------|------------|--------|
| **BLEU-1** | Word overlap | >0.5 | 0.45 | ⚠️ Moderate |
| **BLEU-4** | Phrase overlap | >0.3 | 0.25 | ⚠️ Moderate |
| **NLI Entailment** | Semantic correctness | >0.7 | 0.70 | ✅ Good |
| **NLI Contradiction** | Error rate | <0.15 | 0.10 | ✅ Good |

**Overall**: Your model performs **semantically well** (NLI) but could improve **exact phrase matching** (BLEU). This is acceptable for zero-shot evaluation!

---

*For more details, see the evaluation code in `src/evaluation/`*

