import xlwings as xw
import pandas as pd
import PCA, kNN

# Testing arguments
arg1 = (1, 1)
arg2 = (1, 14)
arg3 = (2, 1)
arg4 = (31, 14)

# Capture the data
wb = xw.apps.active.books.active
ws = wb.sheets['main_sheet']
df = ws.range(arg3, arg4).options(pd.DataFrame, index=False, header=False).value
header = ws.range(arg1, arg2).value
df.columns = header
df = df.reset_index(drop=True)

# PCA & kNN analysis
df_pca = PCA.pca_func(df)
df_train, df_test = kNN.knn_func(df_pca)
df_analysis = pd.concat([df_train, df_test], axis=0)

# Write to excel
wb = xw.apps.active.books.active

sheet_names = [sheet.name for sheet in wb.sheets]
if 'wine-test' in sheet_names:
    sheet = wb.sheets['wine-test']
else:
    sheet = wb.sheets.add(name='wine-test', before=None, after=None)

sheet.range('A1').options(expand='table').value = df_analysis