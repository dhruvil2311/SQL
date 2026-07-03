# SQL Data Portfolio: Exploration & Cleaning

Welcome to my SQL portfolio repository. This repository contains end-to-end SQL projects focusing on two critical aspects of data analytics: **Exploratory Data Analysis (EDA)** and **Data Cleaning**. 

## Repository Structure

* **`Covid_data_exploration.sql`**: Comprehensive script exploring global COVID-19 metrics (Infections, Deaths, Vaccinations).
* **`Nashville_Housing_data_cleaning.sql`**: Full data cleaning and transformation script transforming raw housing records into usable data.
* **`CovidDeaths.xlsx` / `CovidVaccinations.xlsx` / `Nashville Housing Data.xlsx`**: The underlying datasets utilized for these projects.

---

## Project 1: COVID-19 Data Exploration
**File:** `Covid_data_exploration.sql`

This project focuses on uncovering trends, infection rates, and vaccination rollouts across global populations using advanced SQL techniques.

### Key SQL Skills Applied
* **Joins & CTEs:** Combining death metrics and vaccination progress by location and date.
* **Window Functions:** Using to create running totals of rolling vaccinations.
* **Aggregate Functions:** Analyzing maximum infection rates and global death counts per population.
* **Temp Tables & Views:** Storing temporary segments for multi-step calculations and creating permanent views for future Power BI/Tableau visualizations.

### Core Objectives & Queries
* Calculating the likelihood of dying if you contract COVID-19 in specific countries.
* Identifying countries with the highest infection rates compared to their population.
* Breaking down global death metrics by continent to pinpoint highly impacted regions.

---

## Project 2: Nashville Housing Data Cleaning
**File:** `Nashville_Housing_data_cleaning.sql`

Raw data is rarely ready for analysis. This project takes a messy real estate dataset containing over 56,000 rows and executes rigorous data transformations to make it structurally sound.

### Data Cleaning Processes Implemented
1.  **Standardizing Date Formats:** Converting datetime stamps into clean, standard `DATE` formats.
2.  **Populating Missing Data:** Using a `PropertyAddress` self-join to dynamically fill in missing addresses based on matching `ParcelID`s.
3.  **Removing Duplicates:** Employing `ROW_NUMBER()` inside a CTE to isolate and delete duplicate rows.
4.  **Dropping Unused Columns:** Safely removing unneeded, redundant columns to optimize table size and layout.
