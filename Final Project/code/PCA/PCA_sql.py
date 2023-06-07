import json
import mysql.connector
import getpass
import pandas as pd

with open('config.json') as f:
    config = json.load(f)

host_name = config['host']
user_name = config['user']
passwd = getpass.getpass(prompt='Enter your password: ')
csv_path = config['csv_path']

cnx = mysql.connector.connect(user=user_name, password=passwd, host=host_name)

cursor = cnx.cursor()
cursor.execute("DROP DATABASE IF EXISTS DB_wine")
cursor.execute("CREATE DATABASE IF NOT EXISTS DB_wine")
cursor.execute("USE DB_wine")

# Define the table name and columns
table_name = 'wine'
header = ['Class', 'Alcohol', 'Malicacid', 'Ash', 'Alcalinity_of_ash', 'Magnesium', 'Total_phenols', 'Flavanoids', 'Nonflavanoid_phenols', 'Proanthocyanins', 'Color_intensity', 'Hue', '0D280_0D315_of_diluted_wines', 'Proline']
columns = ', '.join([f"`{column}` VARCHAR(255)" for column in header])

# Create the table
create_table_query = f"CREATE TABLE `{table_name}` ({columns}) ENGINE=InnoDB"
cursor.execute(create_table_query)

df = pd.read_csv(csv_path)

# Insert the data into the table
for _, row in df.iterrows():
    values = ", ".join([f"'{str(value)}'" for value in row])
    insert_query = f"INSERT INTO `{table_name}` VALUES ({values})"
    cursor.execute(insert_query)

# Commit the changes and close the connection
cnx.commit()

from sklearn.decomposition import PCA
import numpy as np
from sklearn.preprocessing import LabelEncoder
import matplotlib.pyplot as plt

# Execute a SELECT query to fetch data from the table
select_query = f"SELECT * FROM wine"
cursor.execute(select_query)

# Fetch all the rows from the result set
rows = cursor.fetchall()

# Get the column names from the cursor description
columns = [column[0] for column in cursor.description]

# Convert the fetched data into a pandas DataFrame
df = pd.DataFrame(rows, columns=columns)

# Close the cursor and connection
cursor.close()
cnx.close()

import PCA

df.columns = header

# PCA analysis
df_pca = PCA.pca_func(df)