# UK Road Safety Analytics

MySQL project using UK Department for Transport road safety data to analyse collisions, vehicles and casualties.

## Dataset

Official source:
[https://www.gov.uk/government/statistical-data-sets/road-safety-open-data](https://www.gov.uk/government/statistical-data-sets/road-safety-open-data)

Download the latest 5-year CSV files for:

* Collisions
* Vehicles
* Casualties

## How to Run

1. Download the three CSV files.
2. In `02_Create_Tables.sql`, replace the `/PATH/TO/...` placeholders with your local file paths.
3. Ensure `LOAD DATA LOCAL INFILE` is enabled.
4. Run the SQL files in this order:

   01_Create_Database.sql
   02_Create_Tables.sql
   03_Data_Cleaning.sql
   04_Lookup_Tables.sql
   05_Constraints.sql
   06_Analysis_Queries.sql
   07_CRUD_Transactions.sql
   08_Views.sql
   09_Routines_Triggers.sql
   10_Indexes_Optimization.sql
   11_Tests.sql

## Expected Row Counts

| Table     |    Rows |
| --------- | ------: |
| Collision | 513,801 |
| Vehicle   | 937,265 |
| Casualty  | 652,821 |

## Project Includes

* Relational schema and ERD
* Data cleaning and validation
* Lookup tables, constraints and foreign keys
* CRUD and transactions
* Views, procedures, functions and triggers
* Advanced SQL analysis
* Indexing and `EXPLAIN ANALYZE`
* Final validation tests

## Technology

MySQL · SQL · DataGrip / MySQL Workbench
