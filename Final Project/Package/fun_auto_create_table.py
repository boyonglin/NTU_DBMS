import pandas as pd
import mysql.connector

def create_table(df,host,user,passwd,table_name):
    cnx = mysql.connector.connect(host=host, user=user, passwd=passwd)
    cursor = cnx.cursor()
    cursor.execute("CREATE DATABASE IF NOT EXISTS ECSQL")
    cursor.execute("USE ECSQL")

    # Create table
    columns = ', '.join([f"`{column}` VARCHAR(255)" for column in df.columns])
    create_table_query = f"CREATE TABLE IF NOT EXISTS `{table_name}` ({columns}) ENGINE=InnoDB"
    cursor.execute(create_table_query)

    # Check if the index exists, if not, create one
    non_cluster_index_check = f"SELECT 1 FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = 'ECSQL' AND TABLE_NAME = '{table_name}' AND INDEX_NAME = 'Predict'"
    create_non_cluster_index = f"CREATE INDEX Predict ON `{table_name}` (Predict)"
    cursor.execute(non_cluster_index_check)
    result = cursor.fetchone()

    if not result:
        cursor.execute(create_non_cluster_index)
     
    # Insert value into table
    for _, row in df.iterrows():
        values = ", ".join([f"'{str(value)}'" for value in row])
        insert_query = f"INSERT INTO `{table_name}` VALUES ({values})"
        cursor.execute(insert_query)
    cnx.commit()
    return 

def search_query(host,user,passwd,table_name,n,database='ECSQL'):
    mydb = mysql.connector.connect(host=host, database = database,user=user, passwd=passwd,use_pure=True)
    query = f"Select * from {table_name} WHERE `Class` = {n} ;"
    df = pd.read_sql(query,mydb)
    mydb.close()
    return df