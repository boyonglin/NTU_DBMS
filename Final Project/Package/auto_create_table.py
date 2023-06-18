import pandas as pd
import mysql.connector

def create_table(df,host,user,passwd,table_name):
    cnx = mysql.connector.connect(host=host, user=user, passwd=passwd)
    cursor = cnx.cursor()
    cursor.execute("CREATE DATABASE IF NOT EXISTS ECSQL")
    cursor.execute("USE ECSQL")
    columns = ', '.join([f"`{column}` VARCHAR(255)" for column in df.columns])
    create_table_query = f"CREATE TABLE `{table_name}` ({columns}) ENGINE=InnoDB"
    # cluster_query = f"CREATE INDEX cluster_idx ON `{table_name}` (0);"
    non_cluster_index = f"CREATE INDEX non_idx ON `{table_name}` (Class, Predict);"
    
    cursor.execute(create_table_query)
    # cursor.execute(cluster_query)
    cursor.execute(non_cluster_index)
    
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