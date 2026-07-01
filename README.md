# Credit Risk Early Warning System

Takes a loan dataset of 75,000 records, engineers risk features from raw financial data, segments borrowers into Low/Medium/High Risk, and flags customers who need early intervention — before they default.

## The problem

Raw loan data has fields like CreditScore, DTIRatio, and LoanAmount, but no single field tells you how risky a borrower actually is. This project combines those signals into a weighted risk score, segments borrowers, and flags the ones worth watching — giving a credit team something actionable instead of a spreadsheet they have to interpret themselves.

## How the risk score is built

Four raw features are normalized to 0–1 first (MinMaxScaler), then combined with weights that reflect standard credit risk practice:

```
Risk Score = 0.30 × DTI Ratio
           + 0.25 × Loan-to-Income Ratio
           + 0.20 × Credit Risk Factor  (= 850 - CreditScore, so higher = riskier)
           + 0.15 × Interest Rate
           + 0.10 × (1 - Employment Stability)
```

Scaled to 0–100 for readability.

**Why normalize first?** DTI is a ratio (0–1), CreditScore is 300–850, LoanAmount is raw currency — you can't add these directly. Normalizing puts them on the same scale before the weighted sum.

## Engineered features

| Feature | Formula | Why it matters |
|---|---|---|
| Loan-to-Income | LoanAmount / Income | How much annual income is being borrowed |
| Credit Risk Factor | 850 − CreditScore | Inverts the score so higher = riskier |
| Employment Stability | MonthsEmployed / max(MonthsEmployed) | Normalized job tenure |

## Results

| Risk Category | Customers | Default Rate |
|---|---|---|
| Low Risk (score < 40) | 36,101 | 7.9% |
| Medium Risk (score 40–70) | 38,478 | 14.8% |
| High Risk (score > 70) | 421 | 44.4% |

**Early Warning Flag:** triggered when Risk Score > 75, OR DTI > 0.6, OR CreditScore < 500 — any single extreme indicator is enough, regardless of the composite score.

**45,977 customers flagged** for early intervention out of 75,000 total.
**Overall default rate: 11.65%**

## SQL analysis (Credit_Risk_System.sql)

11 queries covering:
- Default rate by risk category and income group
- RANK() to rank all customers by risk score
- CTE to isolate and summarize the High Risk portfolio
- Risk distribution by employment type and loan purpose
- Average DTI, loan-to-income ratio, and interest rate per risk segment

## Dataset

75,000 loan records, 24 columns — LoanID, Age, Income, LoanAmount, CreditScore, MonthsEmployed, DTIRatio, InterestRate, LoanTerm, HasMortgage, HasDependents, LoanPurpose, HasCoSigner, Default (target), and the engineered features above.

## Files

```
Credit-Risk-Early-Warning-System/
├── Credit_Risk.ipynb           # Feature engineering, scoring, segmentation
├── Credit_Risk_System.sql      # 11 SQL queries for analysis and reporting
├── credit_risk_ews_final.csv   # Output dataset with risk scores and flags
└── README.md
```

## How to run



## Tech stack

Python, Pandas, NumPy, Scikit-learn (MinMaxScaler), Matplotlib, Seaborn, MySQL
