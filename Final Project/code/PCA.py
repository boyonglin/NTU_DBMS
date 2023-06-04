import pandas as pd
from sklearn.decomposition import PCA
import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import LabelEncoder

def pca_func(df):
    # PCA analysis
    pca = PCA(n_components=3)  # specify dimensions for PCA
    class_var = df['Class']
    features = df.drop('Class', axis=1)  # Exclude the target variable 'Class' from the trait
    pca_result = pca.fit_transform(features)

    # Convert categorical variables to numerical representations
    label_encoder = LabelEncoder()
    class_encoded = label_encoder.fit_transform(class_var)

    # explained variance ratio: the percentage of variance that is attributed by each of the selected components
    explained_variance_ratio = pca.explained_variance_ratio_
    print('Explained Variance Ratio:', explained_variance_ratio)

    # cumulative explained variance ratio
    cumulative_explained_variance_ratio = np.cumsum(explained_variance_ratio)
    print('Cumulative Explained Variance Ratio:', cumulative_explained_variance_ratio)

    # Create DataFrame with principal components
    df_pca = pd.DataFrame(pca_result, columns=['PC1', 'PC2', 'PC3'])
    df_pca['Class'] = class_encoded
    print(df_pca.head())

    # Plot visualization charts using scatter matrix
    # pd.plotting.scatter_matrix(df_pca, c=df_pca['Class'], figsize=(10, 10), marker='o', hist_kwds={'bins': 20})
    # plt.show()

    return df_pca