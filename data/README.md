# Data Source

This dataset is from **DQLAB bootcamp** (a credit risk analysis practice project).

The data is **simulated / dummy data** and does not contain any real customer information.  
Therefore, it is safe to use for portfolio purposes.

---

## Dataset Structure

**Original filename:** `CreditRisk_R.xlsx` (not included in this repository due to privacy concerns and file size)

**Number of observations:** 1000+ customers

**Variables available:**

| Variable Name | Data Type | Description |
|---------------|-----------|-------------|
| `kode_kontrak` | Character | Unique contract ID |
| `pendapatan_setahun_juta` | Numeric | Annual income (in million Rupiah) |
| `kpr_aktif` | Factor (YA/TIDAK) | Active KPR/mortgage status (YES/NO) |
| `durasi_pinjaman_bulan` | Numeric | Loan tenure (in months) |
| `jumlah_tanggungan` | Numeric | Number of dependents |
| `rata_rata_overdue` | Character | Average overdue payment category |
| `risk_rating` | Factor (1-5) | **Target variable** - Credit risk rating (1 = lowest risk, 5 = highest risk) |

---

## Notes for Users

- The file `CreditRisk_R.xlsx` is **not included** in this repository because:
  1. To keep the repository lightweight
  2. The simulated data can be easily recreated with the same structure

- To run the analysis script, you can:
  - Use simulated data with the exact same variable structure
  - Contact the repository owner for further information

---

## First 5 Rows of Data (Structure Example)

| kode_kontrak | pendapatan_setahun_juta | kpr_aktif | durasi_pinjaman_bulan | jumlah_tanggungan | rata_rata_overdue | risk_rating |
|--------------|------------------------|-----------|----------------------|-------------------|--------------------|--------------|
| AGR-000001 | 295 | YA | 48 | 5 | 61 - 90 days | 4 |
| AGR-000011 | 271 | YA | 36 | 5 | 61 - 90 days | 4 |
| AGR-000030 | 159 | TIDAK | 12 | 0 | 0 - 30 days | 1 |
| AGR-000043 | 210 | YA | 12 | 3 | 46 - 60 days | 3 |
| AGR-000049 | 165 | TIDAK | 36 | 0 | 31 - 45 days | 2 |

---

## How to Reproduce the Analysis

1. Create an Excel file named `CreditRisk_R.xlsx`
2. Fill it with the exact variable structure shown above
3. Save it in the `data/` folder (this folder)
4. Run the script `scripts/credit_risk_model.R`

> **Warning:** The original Excel file has been added to `.gitignore` so it will not be uploaded to GitHub. This is standard practice to protect data, even simulated data.
