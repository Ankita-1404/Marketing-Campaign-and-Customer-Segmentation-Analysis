CREATE DATABASE mini_project;
USE mini_project;

-- Step 1: Create the Campaigns table
CREATE TABLE Campaigns (
    campaign_id INT PRIMARY KEY,
    company VARCHAR(100),
    campaign_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    platform VARCHAR(50),
    budget DECIMAL(12,2)
);

-- Step 2: Create the AdGroups table (linked to Campaigns)
CREATE TABLE AdGroups (
    adgroup_id INT PRIMARY KEY,
    campaign_id INT,
    adgroup_name VARCHAR(100),
    target_audience VARCHAR(100),
    bid_type VARCHAR(50),
    FOREIGN KEY (campaign_id) REFERENCES Campaigns(campaign_id)
);

-- Step 3: Create the Ads table (linked to AdGroups)
CREATE TABLE Ads (
    ad_id INT PRIMARY KEY,
    adgroup_id INT,
    ad_name VARCHAR(100),
    ad_format VARCHAR(50),
    FOREIGN KEY (adgroup_id) REFERENCES AdGroups(adgroup_id)
);


-- Step 4: Create the Customers table (independent dimension)
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    country VARCHAR(50),
    gender VARCHAR(20),
    age_group VARCHAR(20),
    device_type VARCHAR(50)
);


-- Step 5: Create the AdPerformance table (linked to Ads & Customers)
CREATE TABLE AdPerformance (
    performance_id INT PRIMARY KEY AUTO_INCREMENT,
    ad_id INT,
    customer_id INT,
    performance_date DATE,
    impressions INT,
    clicks INT,
    conversions INT,
    cost DECIMAL(10,2),
    revenue DECIMAL(10,2),
    FOREIGN KEY (ad_id) REFERENCES Ads(ad_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

SELECT * FROM Campaigns;
SELECT * FROM AdGroups;
SELECT * FROM Ads;
SELECT * FROM Customers;
SELECT * FROM AdPerformance;


-- QUERIES

-- 1) Updating start and end dates for each campaign in Campaigns table.
UPDATE Campaigns
SET start_date = '2025-10-01', end_date = '2025-10-15'
WHERE campaign_id = 1;

UPDATE Campaigns
SET start_date = '2025-10-05', end_date = '2025-10-20'
WHERE campaign_id = 2;

UPDATE Campaigns
SET start_date = '2025-10-10', end_date = '2025-10-25'
WHERE campaign_id = 3;

UPDATE Campaigns
SET start_date = '2025-10-15', end_date = '2025-10-30'
WHERE campaign_id = 4;

UPDATE Campaigns
SET start_date = '2025-10-20', end_date = '2025-11-04'
WHERE campaign_id = 5;

UPDATE Campaigns
SET start_date = '2025-10-25', end_date = '2025-11-10'
WHERE campaign_id = 6;

UPDATE Campaigns
SET start_date = '2025-10-30', end_date = '2025-11-15'
WHERE campaign_id = 7;

UPDATE Campaigns
SET start_date = '2025-11-05', end_date = '2025-11-20'
WHERE campaign_id = 8;

UPDATE Campaigns
SET start_date = '2025-11-10', end_date = '2025-11-25'
WHERE campaign_id = 9;

SELECT campaign_id, company, campaign_name, start_date, end_date
FROM Campaigns
ORDER BY campaign_id;

-- Ensures all campaigns have realistic, recent timeframes for accurate filtering and analysis.


-- 2) Display all active campaigns
SELECT campaign_name, company, start_date, end_date
FROM Campaigns
WHERE CURDATE() BETWEEN start_date AND end_date;


-- 3) Display total campaigns per company
SELECT company, COUNT(*) AS total_campaigns
FROM Campaigns
GROUP BY company;

-- Reveals how many campaigns are being managed for each company.


-- 4) All Campaigns running on Meta
SELECT * FROM Campaigns
WHERE platform = 'Meta';

-- Identifies campaigns running on Meta; useful for comparing cross-platform performance.


-- 5) Campaigns with budget > 30000
SELECT campaign_name, company, budget
FROM Campaigns
WHERE budget > 30000;

-- – Filters higher-budget campaigns, showing strategic investment areas.

-- 6) Campaign Duration (Days)
SELECT campaign_id, campaign_name,
       DATEDIFF(end_date, start_date) AS duration_days
FROM Campaigns
ORDER BY duration_days DESC;

-- Calculates how long each campaign runs; helps plan media scheduling and pacing.


-- 7) Display all ads and the campaign they belong to
SELECT a.ad_id, a.ad_name, c.campaign_name
FROM Ads a
JOIN AdGroups g ON a.adgroup_id = g.adgroup_id
JOIN Campaigns c ON g.campaign_id = c.campaign_id
ORDER BY c.campaign_id, a.ad_id;

-- Displays all ads along with their parent campaigns, verifying the campaign-ad hierarchy.


-- 8) Ads per campaign
SELECT c.campaign_name, COUNT(a.ad_id) AS ads_count
FROM Ads a
JOIN AdGroups g ON a.adgroup_id = g.adgroup_id
JOIN Campaigns c ON g.campaign_id = c.campaign_id
GROUP BY c.campaign_name
ORDER BY ads_count DESC;

-- Counts ads per campaign, showing that each campaign contains 3–4 creative assets.

-- 9) Customers per Country
SELECT country, COUNT(*) AS total_customers
FROM Customers
GROUP BY country
ORDER BY total_customers DESC;



-- 10) Top 10 ads by impressions
SELECT a.ad_id, 
       a.ad_name, 
       SUM(p.impressions) AS total_impressions
FROM AdPerformance p
JOIN Ads a 
    ON p.ad_id = a.ad_id
GROUP BY a.ad_id, a.ad_name
ORDER BY total_impressions DESC
LIMIT 10;

-- Highest Visibility - Prime in 1 Click

-- 11) Overall performance

SELECT SUM(impressions) AS impressions,
       SUM(clicks) AS clicks,
       SUM(conversions) AS conversions,
       ROUND(SUM(cost),2) AS cost,
       ROUND(SUM(revenue),2) AS revenue
FROM AdPerformance;


-- 12) Display Clicks and conversions across different age groups and device types.
SELECT cu.age_group, cu.device_type,
       SUM(p.clicks) AS total_clicks,
       SUM(p.conversions) AS total_conversions
FROM AdPerformance p
JOIN Customers cu 
    ON p.customer_id = cu.customer_id
GROUP BY cu.age_group, cu.device_type
ORDER BY cu.age_group, total_conversions DESC;

-- Young users on desktop devices are the most engaged and conversion-prone audience segment.

-- 13) Recent performance records (last 7 days)
SELECT *
FROM AdPerformance
WHERE performance_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
ORDER BY performance_date DESC;

-- 14) Conversions by age group
SELECT cu.age_group, SUM(p.conversions) AS total_conversions
FROM AdPerformance p
JOIN Customers cu ON p.customer_id = cu.customer_id
GROUP BY cu.age_group
ORDER BY total_conversions DESC;


-- 15) Engagement by device
SELECT cu.device_type, SUM(p.clicks) AS total_clicks
FROM AdPerformance p
JOIN Customers cu ON p.customer_id = cu.customer_id
GROUP BY cu.device_type
ORDER BY total_clicks DESC;

-- 16) Performance with campaign names
SELECT c.company, c.campaign_name, a.ad_name, p.impressions, p.clicks
FROM AdPerformance p
JOIN Ads a      ON a.ad_id       = p.ad_id
JOIN AdGroups g ON g.adgroup_id  = a.adgroup_id
JOIN Campaigns c ON c.campaign_id = g.campaign_id
ORDER BY c.campaign_id, a.ad_id, p.performance_date;

-- 17) Device type by ad format (who engages where)
SELECT cu.device_type, a.ad_format, COUNT(*) AS interactions
FROM AdPerformance p
JOIN Ads a ON a.ad_id = p.ad_id
JOIN Customers cu ON cu.customer_id = p.customer_id
GROUP BY cu.device_type, a.ad_format
ORDER BY interactions DESC;


-- 18) Which platform delivers the most conversions?  -- okay
SELECT c.platform, SUM(p.conversions) AS total_conversions
FROM AdPerformance p
JOIN Ads a ON a.ad_id = p.ad_id
JOIN AdGroups g ON g.adgroup_id = a.adgroup_id
JOIN Campaigns c ON c.campaign_id = g.campaign_id
GROUP BY c.platform
ORDER BY total_conversions DESC;

-- Google Ads is the most engaged ad with highest conversions

-- 19) Average CTR (clicks/impressions) by ad
SELECT a.ad_id,
       ROUND(SUM(p.clicks)/NULLIF(SUM(p.impressions),0),4) AS avg_ctr
FROM AdPerformance p
JOIN Ads a ON a.ad_id = p.ad_id
GROUP BY a.ad_id
ORDER BY avg_ctr DESC;


-- 20) Cost per click (CPC) overall
SELECT ROUND(SUM(cost)/NULLIF(SUM(clicks),0), 2) AS cpc
FROM AdPerformance;

-- 21) Daily revenue trend (last 30 days)
SELECT performance_date, SUM(revenue) AS daily_revenue
FROM AdPerformance
GROUP BY performance_date
ORDER BY performance_date;

-- 223 Most Active Age Group
SELECT cu.age_group,
       SUM(p.impressions) AS total_impressions,
       SUM(p.clicks) AS total_clicks,
       SUM(p.conversions) AS total_conversions,
       ROUND(SUM(p.clicks)/NULLIF(SUM(p.impressions),0)*100,2) AS CTR_percent
FROM AdPerformance p
JOIN Customers cu 
    ON p.customer_id = cu.customer_id
GROUP BY cu.age_group
ORDER BY total_clicks DESC;


-- 23) Revenue by country
SELECT cu.country, ROUND(SUM(p.revenue),2) AS revenue
FROM AdPerformance p
JOIN Customers cu ON p.customer_id = cu.customer_id
GROUP BY cu.country
ORDER BY revenue DESC;

SELECT * FROM Customers WHERE age_group = '46-60';

