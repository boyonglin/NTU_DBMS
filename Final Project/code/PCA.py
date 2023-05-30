import pandas as pd
from sklearn.decomposition import PCA
import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import LabelEncoder

# 讀取 csv 數據到 Pandas DataFrame
df = pd.read_csv('./UCI/wine-data.csv', header=None)

# wine-data
header = ['Class', 'Alcohol', 'Malicacid', 'Ash', 'Alcalinity_of_ash', 'Magnesium', 'Total_phenols', 'Flavanoids', 'Nonflavanoid_phenols', 'Proanthocyanins', 'Color_intensity', 'Hue', '0D280_0D315_of_diluted_wines', 'Proline']
# iris-data
# header = ['Sepal_length', 'Sepal_width', 'Petal_length', 'Petal_width', 'Class']
# dry-bean-data
# header = ['Area', 'Perimeter', 'Major_axis_length', 'Minor_axis_length', 'Aspect_ration', 'Eccentricity', 'Convex_area', 'Equiv_diameter', 'Extent', 'Solidity', 'Roundness', 'Compactness', 'Shape_factor_1', 'Shape_factor_2', 'Shape_factor_3', 'Shape_factor_4', 'Class']
df.columns = header

# 執行 PCA 分析
pca = PCA(n_components=3)  # 指定 PCA 的維度
class_var = df['Class']
features = df.drop('Class', axis=1)  #  從特徵中排除目標變數 Class
pca_result = pca.fit_transform(features)

# 將類別變數轉換為數值表示
label_encoder = LabelEncoder()
class_encoded = label_encoder.fit_transform(class_var)

# 解釋變異性比例
explained_variance_ratio = pca.explained_variance_ratio_
print('Explained Variance Ratio:', explained_variance_ratio)

# 累積解釋變異性比例
cumulative_explained_variance_ratio = np.cumsum(explained_variance_ratio)
print('Cumulative Explained Variance Ratio:', cumulative_explained_variance_ratio)

# 創建包含主成分的 DataFrame
df_pca = pd.DataFrame(pca_result, columns=['PC1', 'PC2', 'PC3'])
df_pca['Target'] = class_encoded
print(df_pca.head())

# 使用散點矩陣繪製可視化圖表
pd.plotting.scatter_matrix(df_pca, c=df_pca['Target'], figsize=(10, 10), marker='o', hist_kwds={'bins': 20})
plt.show()

