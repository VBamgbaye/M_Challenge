# Data_Engineering Challenge

This is a task to retrieve publicly available data and perform analysis on that data using SQL.
The data were obtained through different means and format. The first dataset obtained from World Bank API is World Bank 
data which was extracted in a json format. The second dataset is a GDP data download from the source as .csv

Therefore, in this GitHub repo are three .py files or modules to handle the extraction, processing and staging the data
in a postgresql database.
A .sql file which contains all analysis done on data.

## Getting Started
1. data_grab.py - This module extracts the World Bank data, it cleans and saves the data in a both json and csv file for reference.
2. process_csv.py - This module reads the csv files and process (JOINS & converting to dataframe) before it is staged.
3. stage_data.py - Module handles the staging of data. It creates the tables and saves data to the database.
4. To begin;
   1. Download package by using pip install M-challenge in console
   2. Make sure all csv files are downloaded and located in the same the directory the .py files are located.
   3. Run 'python -m data_etl' on the console.
   4. Enter you credentials when a prompt to enter database password and host pops up.
5. Once the information is passed in, the process begins and the data is extracted and staged.