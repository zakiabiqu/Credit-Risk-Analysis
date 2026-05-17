# Credit Risk Analysis Using C5.0 Decision Tree

**Author:** Zaki Abiyu Aqilah  
**Tools:** R (openxlsx, C50, reshape2)  
**Goal:** Predict credit risk rating (1–5) based on customer profile

---

## Project Overview

This project builds a **C5.0 decision tree model** to classify loan applicants into five risk categories (1 = lowest risk, 5 = highest risk). The model helps financial institutions make data-driven credit approval decisions.

**Key Results:**
- **Testing Accuracy: 96%**
- Correct predictions: 96 out of 100
- Most important feature: Active KPR status (100% importance)

---

## Dataset

The dataset contains **1,000+ loan applications** with the following variables:

| Variable | Type | Description |
|----------|------|-------------|
| `pendapatan_setahun_juta` | Numeric | Annual income (million Rupiah) |
| `kpr_aktif` | Factor | Active mortgage status (YA/TIDAK) |
| `durasi_pinjaman_bulan` | Numeric | Loan tenure (months) |
| `jumlah_tanggungan` | Numeric | Number of dependents |
| `risk_rating` | Factor (1-5) | **Target variable** |

> **Note:** The original Excel file is not included in this repository. See [`data/README.md`](data/README.md) for data structure details.

---

## Model Performance

### Confusion Matrix (Testing Set: 100 cases)

| Predicted \ Actual | 1 | 2 | 3 | 4 | 5 |
|:------------------:|:-:|:-:|:-:|:-:|:-:|
| **1** | 20 | 0 | 0 | 0 | 0 |
| **2** | 4 | 13 | 0 | 0 | 0 |
| **3** | 0 | 0 | 38 | 0 | 0 |
| **4** | 0 | 0 | 0 | 9 | 0 |
| **5** | 0 | 0 | 0 | 0 | 16 |

### Performance Metrics

| Metric | Value |
|--------|-------|
| Accuracy | **96%** |
| Correct Predictions | 96 / 100 |
| Wrong Predictions | 4 / 100 |
| Tree Size | 17 rules |

### Variable Importance

| Variable | Importance (%) |
|----------|----------------|
| `kpr_aktif` (Active KPR) | 100.00 |
| `jumlah_tanggungan` (Dependents) | 75.50 |
| `pendapatan_setahun_juta` (Annual Income) | 68.13 |
| `durasi_pinjaman_bulan` (Loan Tenure) | 57.13 |

> **Insight:** Active KPR status is the most dominant factor in determining credit risk rating.

---

## Decision Tree Rules (Simplified)

### If `kpr_aktif = YA` (Has active mortgage):
- **Dependents ≤ 4** → Risk Rating **3** (255 cases)
- **Dependents > 4**:
  - Income > 248 million → Risk Rating **4**
  - Income ≤ 248 million:
    - Loan tenure ≤ 24 months → Risk Rating **4**
    - Loan tenure > 24 months → Risk Rating **5**

### If `kpr_aktif = TIDAK` (No active mortgage):
- **Income ≤ 95 million** → Risk Rating **2**
- **Income > 95 million**:
  - Loan tenure > 36 months → Risk Rating **2**
  - Loan tenure ≤ 36 months:
    - Income > 201 million → Risk Rating **1**
    - Income ≤ 201 million → (further splits, see full output)

---

## Predictions on New Applications

Three sample applications were tested:

| Application | Income (M) | Active KPR | Tenure (months) | Dependents | Predicted Risk |
|-------------|------------|------------|-----------------|------------|:--------------:|
| App 1 | 200 | YA | 12 | 6 | **4** (High Risk) |
| App 2 | 150 | TIDAK | 64 | 6 | **2** (Low Risk) |
| App 3 | 300 | TIDAK | 24 | 2 | **1** (Lowest Risk) |

---

## How to Run the Code

1. Clone this repository  
2. Place your Excel file (CreditRisk_R.xlsx) in the data/ folder  
3. Run script/model.R in RStudio or R console

