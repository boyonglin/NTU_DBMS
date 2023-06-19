import xlwings as xw
import pandas as pd
import fun_PCA, fun_kNN , fun_auto_create_table
import sys
import json

# Testing arguments
arg1 = int(sys.argv[1])
arg2 = int(sys.argv[2])
arg3 = int(sys.argv[3])
arg4 = int(sys.argv[4])
host = sys.argv[5]
user = sys.argv[6]
passwd = sys.argv[7]

# Capture the data
wb = xw.apps.active.books.active
ws = wb.sheets['main-sheet']
df = ws.range((arg1+1, arg2), (arg3, arg4)).options(pd.DataFrame, index=False, header=False).value
header = ws.range((arg1, arg2),(arg1, arg4)).value
df.columns = header
df = df.reset_index(drop=True)

# PCA & kNN analysis
df_pca = fun_PCA.pca_func(df)
df_train, df_test = fun_kNN.knn_func(df_pca)
df_analysis = pd.concat([df_train, df_test], axis=0)
df_analysis = df_analysis.reset_index(drop=True)
df_result = pd.concat([df,df_analysis['Predict']], axis=1)

# To mysql
fun_auto_create_table.create_table(df_result,host=host,user=user,passwd=passwd,table_name='example')

# Write to excel
wb = xw.apps.active.books.active

sheet_names = [sheet.name for sheet in wb.sheets]
if 'wine-test' in sheet_names:
    sheet = wb.sheets['wine-test']
else:
    sheet = wb.sheets.add(name='wine-test', before=None, after='main-sheet')

sheet.range('A1').options(expand='table').value = df_analysis