# Job-Placement-SQL-Power-BI
SQL Server + Power BI analysis of MBA candidate placement outcomes — pipeline analysis, score correlation, and data governance auditing.
Job Placement Analytics — SQL & Power BI Case Study

Project Overview

This project analyzes candidate placement outcomes for an MBA cohort, examining how academic background, work experience, test performance, and demographic factors relate to job placement success. Using SQL Server for data modeling and analysis, and Power BI for visualization, the project demonstrates a complete BI workflow — from raw data inspection through to an interactive, stakeholder-ready dashboard.

The Problem

Organizations running placement or recruitment pipelines need to understand which candidate attributes actually correlate with successful outcomes, in order to refine selection criteria, identify at-risk candidates early, and report performance to stakeholders with confidence. This project works with a real 215-candidate dataset (sourced from Kaggle) to answer exactly that kind of question, while also applying a data governance lens — auditing the dataset for completeness and consistency before drawing conclusions from it.

Process

Data Inspection & Modeling
The dataset was inspected for nulls, duplicate records, invalid value ranges, and categorical inconsistencies before any analysis began. Given the dataset's flat, single-entity structure — one row per candidate, no repeating or time-based dimensions — a deliberate decision was made to forgo a star schema in favor of a single well-typed table, avoiding unnecessary joins that would add complexity without analytical benefit. A surrogate candidate_id key was added to support row-level referencing and auditing.

SQL Analysis
Thirteen analytical views were built in SQL Server, covering:
— Placement rate breakdowns by specialisation, work experience, academic background, gender, and exam board type
— Score-based analysis comparing average academic and test performance between placed and non-placed candidates
— Score banding and percentile ranking using window functions (PERCENT_RANK)
— A leaderboard of top-performing candidates
— A two-part data governance audit: a row-level completeness scoring framework and a logical consistency check validating value ranges and categorical integrity
— A factor-influence comparison view, quantifying the size of the placement-rate gap across each candidate attribute

Each view was built using conditional aggregation, CASE-based binning, and window functions, with inline documentation explaining the reasoning behind every technique used.

Power BI Dashboard
The SQL views were connected directly to Power BI Desktop and organized across six dashboard pages: Overview, Pipeline Factors, Score Analysis, Leaderboard, Data Quality & Governance, and a Key Influencers page using Power BI's built-in statistical influencer detection to surface the strongest predictors of placement automatically.

Key Findings

— Work experience and employability test performance show the most pronounced association with placement outcomes among the factors tested
— The dataset passed a full completeness and consistency audit with no missing values or invalid entries — a governance check performed regardless of the clean result, to demonstrate the audit habit itself rather than only reacting to known problems
— Score-based factors (test performance, MBA percentage) showed a stronger relationship with placement than earlier academic history (secondary school scores), suggesting more recent performance signals carry more predictive weight than early academic record

Skills Demonstrated

SQL Server (data cleaning, view design, window functions, conditional aggregation, CTEs) • Power BI (dashboard design, DAX, Key Influencers analysis) • Data modeling and schema decision-making • Data quality auditing and completeness scoring • Translating analytical findings into stakeholder-relevant insight

GitHub Repository: [insert your repo link]
Dataset Source: Kaggle — Job Placement Dataset (ahsan81)
