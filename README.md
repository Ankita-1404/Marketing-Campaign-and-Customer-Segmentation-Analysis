# Marketing Campaign & Customer Segmentation Analysis

A normalized (3NF) relational database and SQL analysis of a simulated multi-brand digital marketing agency — covering campaign performance, customer segmentation, and channel/platform effectiveness across Nike, Amazon, and Samsung.

## Overview

| Metric | Value |
|---|---|
| Campaigns | 9 (across Nike, Amazon, Samsung) |
| Ad Groups | 25 |
| Ads | 33 |
| Customers | 50 |
| Performance Records | 500 |
| Total Impressions | 1,717,693 |
| Total Clicks | 154,572 |
| Total Conversions | 30,971 |
| Total Spend | $1,555,816.86 |
| Total Revenue | $2,958,790.30 |
| Overall CPC | $10.07 |

## Schema

A 5-table normalized design (3NF):

```
Campaigns (1) ──< AdGroups (1) ──< Ads (1) ──< AdPerformance >── (1) Customers
```

- **Campaigns** — company, platform, budget, timeframe
- **AdGroups** — target audience & bid type, linked to a campaign
- **Ads** — ad creative/format, linked to an ad group
- **Customers** — country, gender, age group, device type (independent dimension)
- **AdPerformance** — daily impressions/clicks/conversions/cost/revenue, linking an ad to a customer

## Key Insights

1. **Google Ads is the highest-converting channel** — 12,985 conversions, ahead of YouTube (8,133), Meta (6,749), and LinkedIn (3,104).
2. **India and USA are the top revenue markets** — India ($678,938.54) narrowly leads USA ($649,277.55), followed by Germany, France, and Canada.
3. **60+ on Mobile is the most-engaged segment** — this group leads all age/device combinations in conversions (6,334), followed by 60+ on Desktop (3,626) and 18–25 on Desktop (3,007) — a notably different picture from the "younger users" assumption.
4. **Balanced campaign load per company** — Nike, Amazon, and Samsung each run exactly 3 campaigns, with most campaigns supported by 3–4 ads.
5. **Overall CPC of $10.07** across all campaigns, giving a baseline to benchmark individual ad/platform efficiency against.

## Files

- `mini_project.sql` — full schema (DDL) + 23 analysis queries
- `Campaigns.csv`, `AdGroups.csv`, `Ads.csv`, `Customers.csv`, `AdPerformance.csv` — source data tables

## What the SQL Covers

- Schema creation with primary/foreign key constraints across all 5 tables
- Campaign filtering (active campaigns, platform, budget thresholds, duration)
- Hierarchy joins (ad → ad group → campaign)
- Performance aggregation (impressions, clicks, conversions, cost, revenue)
- Customer segmentation (age group × device type, country)
- Derived metrics (CTR, CPC, daily revenue trend)
- Platform-level and country-level revenue/conversion comparisons

## Tools Used

- **SQL (MySQL)** — schema design, joins, aggregation, segmentation queries

## How to Run

1. Import the CSVs into a MySQL instance (or use the `CREATE TABLE` statements in `mini_project.sql` and load data with `LOAD DATA INFILE`).
2. Run `mini_project.sql` in your MySQL client (e.g. MySQL Workbench, DBeaver) to build the schema and execute the analysis queries.
