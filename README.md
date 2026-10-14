# Data Warehouse & Analytics Project

Hi, Welcome to the **Data Warehouse and Analytics Project** repository!

## Data Architechture
The data architechture of this project follows Medallion Architechture **Bronze**, **Silver** and **Gold** layers:
![Data Architechture](docs/Data_Warehouse_Architechture.png)

1. **Bronze Layer**: Stores row data as-is from the source systems. Data is ingested from CSV files into SQL Server database.
2. **Silver Layer**: This layer   includes data cleansing, standardzation and normalization processes to prepair data for analysis.
3. **Gold Layer**: Houses business-ready modeled into a star schema required for reporting and analysis.
