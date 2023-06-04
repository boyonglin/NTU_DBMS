import xlwings as xw
import pandas as pd
import PCA

# Read from excel
file_path = 'example.xlsx'
wb = xw.Book(file_path)
ws = wb.sheets['wine-data']
df = ws.used_range.options(pd.DataFrame, index=False, header=False).value
# df = wb.range('A1:C10').options(pd.DataFrame, index=False, header=False).value

# Set header
header = ['Class', 'Alcohol', 'Malicacid', 'Ash', 'Alcalinity_of_ash', 'Magnesium', 'Total_phenols', 'Flavanoids', 'Nonflavanoid_phenols', 'Proanthocyanins', 'Color_intensity', 'Hue', '0D280_0D315_of_diluted_wines', 'Proline']  # wine-data
# header = ['Sepal_length', 'Sepal_width', 'Petal_length', 'Petal_width', 'Class']  # iris-data
# header = ['Area', 'Perimeter', 'Major_axis_length', 'Minor_axis_length', 'Aspect_ration', 'Eccentricity', 'Convex_area', 'Equiv_diameter', 'Extent', 'Solidity', 'Roundness', 'Compactness', 'Shape_factor_1', 'Shape_factor_2', 'Shape_factor_3', 'Shape_factor_4', 'Class']  # dry-bean-data
df.columns = header

# PCA analysis
df_pca = PCA.pca_func(df)

# Write to excel
wb = xw.Book('example.xlsx')
wb.sheets.add(name='wine-pca', before=None, after=None)
sheet = wb.sheets['wine-pca']
sheet.range('A1').options(expand='table').value = df_pca