import pandas as pd
import psycopg2
from sqlalchemy import create_engine
from M_Challenge.data_grab import GetData


class StageData(GetData):
    """
        This class stages fully processed data treated from the data_grab module on to a postgresql database

        class attributes:
            tablename1 & tablename2 (str): Names assigned to the tables created in the database
            data (int): holds data that's read in from a csv file
            conn & engine (str): postgresql connection details
        """

    def __init__(self, password, host):
        self.df = GetData()
        self.tablename1 = "world_bank"
        self.tablename2 = "gdp"
        self.data = pd.read_csv("./GEPData.csv",
                                usecols=['country_name', 'country_code', 'indicator_name', 'indicator_code', '1999',
                                         '2000', '2001', '2002', '2003', '2004', '2005', '2006', '2007', '2008', '2009',
                                         '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017', '2018', '2019',
                                         '2020', '2021', '2022'])
        self.password = password
        self.host = host
        self.engine = create_engine(f"postgresql+psycopg2://postgres:{password}@{host}:5432/finance")
        self.conn = psycopg2.connect(f"dbname=finance user=postgres password={password} host={host} port=5432")

    def create_tables(self):
        cursor = self.conn.cursor()
        cursor.execute("DROP TABLE IF EXISTS world_bank")
        cursor.execute(
            "CREATE TABLE world_bank (id VARCHAR(3), iso2Code VARCHAR(2), country_name VARCHAR(100), region_id "
            "VARCHAR(3), region_iso2code VARCHAR(2), region_value VARCHAR(100), admin_region_id VARCHAR(3),"
            "admin_region_iso2code VARCHAR(2), admin_region_value VARCHAR(100), income_level_id VARCHAR(3),"
            "income_level_iso2code VARCHAR(2), income_level_value VARCHAR(30), lending_type_id VARCHAR(3),"
            "lending_type_iso2code VARCHAR(2), lending_type_value VARCHAR(20), capital_city VARCHAR(20),"
            "longitude VARCHAR(10), latitude VARCHAR(10))")
        cursor.execute("DROP TABLE IF EXISTS gdp")
        cursor.execute(
            "CREATE TABLE gdp (country_name VARCHAR(50), country_code VARCHAR(3), indicator_name VARCHAR(30),"
            "indicator_code VARCHAR(15), year_1999 int, year_2000 int, year_2001 int, year_2002 int, year_2003 int, "
            "year_2004 int, year_2005 int, year_2006 int, year_2007 int, year_2008 int, year_2009 int, year_2010 int, "
            "year_2011 int, year_2012 int, year_2013 int, year_2014 int, year_2015 int, year_2016 int, year_2017 int, "
            "year_2018 int, year_2019 int, year_2020 int, year_2021 int, year_2022 int)")
        self.conn.commit()

    def save_to_database(self):
        self.create_tables()
        # Do not store into postgres with an index column
        self.df.json_to_dataframe().to_sql(self.tablename1, self.engine, if_exists='replace', index=False)
        self.data.to_sql(self.tablename2, self.engine, if_exists='replace', index=False)
        print(f"Tables: {self.tablename1} & {self.tablename2} created. Data staged! ")


if __name__ == '__main__':
    sv = StageData(input('Enter password: '), input('Enter host: '))
    sv.save_to_database()
