import json
import mysql.connector
import getpass
import pandas as pd
from sklearn.decomposition import PCA
import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import LabelEncoder
import seaborn as sns

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

# Print the DataFrame
print(df)



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



# KNN - 切割訓練集與測試集
from sklearn.model_selection import train_test_split

X = df_pca.drop('Target', axis=1).values
y = df_pca['Target'].values

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42, stratify=y)

print('train shape:', X_train.shape)
print('test shape:', X_test.shape)



# 建立 k-nearest neighbors(KNN) 模型
from sklearn.neighbors import KNeighborsClassifier

knnModel = KNeighborsClassifier(n_neighbors=3) # n_neighbors: 設定鄰居的數量(k)，選取最近的k個點，預設為5。
# 使用訓練資料訓練模型
knnModel.fit(X_train, y_train)
# 使用訓練資料預測分類
predicted = knnModel.predict(X_test)

from sklearn import metrics

metrics.accuracy_score(y_test, predicted)

print('訓練集: ',knnModel.score(X_train, y_train))



# 建立測試集的 DataFrme
df_test = pd.DataFrame(X_test, columns=['PC1'])
df_test['PC2'] = 0
df_test['PC3'] = 0
df_test['Target'] = y_test
df_test['Predict'] = predicted

# 使用散點矩陣繪製分類結果
plt.scatter(df_test['PC1'], df_test['PC2'], c=df_test['Predict'], marker='o', s=50, label='Predicted')
plt.scatter(df_test['PC1'], df_test['PC2'], c=df_test['Target'], marker='x', s=25, label='Actual')
plt.xlabel('PC1')
plt.ylabel('PC2')
plt.legend()



# 使用 heatmap 繪製 KNN 預測結果的矩陣
confusion_matrix = metrics.confusion_matrix(y_test, predicted)

sns.heatmap(confusion_matrix, annot=True, cmap='Blues', fmt='d')
plt.xlabel('Predicted')
plt.ylabel('Actual')
plt.show()

# 根據 class_encoded，x 軸和 y 軸的 0、1、2 代表 wine dataset 中的三個不同的葡萄酒類別。
# 每格數字表示實際和預測之間的樣本數量，了解 KNN 對每個類別的預測準確性。