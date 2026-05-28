# Football Analysis


## Executive Summary
Analysis of 88 league-seasons across 11 European football leagues (2008–2016) using SQL and Python to quantify home team advantage and its effect on match outcomes. Every league-season in the dataset showed a measurable home advantage, with home teams scoring at least 0.12 more goals per game than away teams on average. La Liga showed the strongest home advantage while the Scottish Premier League showed the weakest.

## Key Visuallizations
![Quantified home team advantage for top 8 European football leagues](images/home_advantage.png)
* Figure 1:
  
![Effect of league home team advantage on home team performance](images/home_result.png)
* Figure 2:

![Point differences season over season for EPL teams](images/point_differences.png)
* Figure 3: 

## Findings
* **Universal home advantage:** Every one of the 88 league-seasons analyzed showed a positive home advantage — home teams consistently outscored away teams regardless of league or season
* **La Liga vs Scottish Premier League:** La Liga had the highest average home advantage across seasons; Scotland's 12-team league with Celtic and Rangers dominating may reduce competitive variance and suppress home advantage
* **Home advantage predicts wins, not draws:** A league's home advantage is a strong predictor of home win rate (R² = 0.74) but a poor predictor of draw rate (R² = 0.08), suggesting draws are driven by other factors
* **EPL Big Six stability:** Most top clubs changed by fewer than 10 points season over season, suggesting consistent performance at the top of the table — with Chelsea's 2015/16 collapse as a notable outlier

## Methodology
Data source: European Soccer Database — 25,000+ matches across 11 leagues, 2008–2016
SQL: Four analyses written in SQLite using CTEs, window functions (RANK, LAG, rolling AVG/SUM), and multi-table joins — see queries/ folder
Python: Results exported from SQL as CSVs and visualized using pandas, matplotlib, seaborn, and plotly
Statistical testing: Linear regression via scipy.stats.linregress used to assess significance of home advantage trends (all results significant at p < 0.05)
