import pandas as pd
from sklearn.neighbors import KNeighborsClassifier
from sklearn import metrics
import matplotlib.pyplot as plt
import seaborn as sns

def knn_func(df_pca):
    # KNN - split training set and test set
    from sklearn.model_selection import train_test_split

    x = df_pca.drop('Class', axis=1).values
    y = df_pca['Class'].values

    x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.3, random_state=42, stratify=y)

    # print('train shape: ', x_train.shape)
    # print('test shape: ', x_test.shape)

    # Create a k-nearest neighbors (KNN) model, set the number of neighbors (n_neighbors), select the nearest k points, the default is 5
    knnModel = KNeighborsClassifier(n_neighbors=3)
    # Train the model using the training data
    knnModel.fit(x_train, y_train)
    # Predict classification using training data
    predicted = knnModel.predict(x_test)
    metrics.accuracy_score(y_test, predicted)

    print('Predictions Accuracy: ',knnModel.score(x_train, y_train))

    # Build the DataFrame of the training set
    df_train = pd.DataFrame(x_train, columns=['PC1', 'PC2', 'PC3'])
    df_train['Class'] = y_train
    df_train['Predict'] = y_train

    # Build the DataFrame of the test set
    df_test = pd.DataFrame(x_test, columns=['PC1', 'PC2', 'PC3'])
    df_test['Class'] = y_test
    df_test['Predict'] = predicted

    # # Plot classification results using scatter matrix
    # plt.scatter(df_test['PC1'], df_test['PC2'], c=df_test['Predict'], marker='o', s=50, label='Predicted')
    # plt.scatter(df_test['PC1'], df_test['PC2'], c=df_test['Class'], marker='x', s=25, label='Actual')
    # plt.xlabel('PC1')
    # plt.ylabel('PC2')
    # plt.legend()

    # # Plot matrix of KNN predictions using heatmap
    # confusion_matrix = metrics.confusion_matrix(y_test, predicted)

    # sns.heatmap(confusion_matrix, annot=True, cmap='Blues', fmt='d')
    # plt.xlabel('Predicted')
    # plt.ylabel('Actual')
    # plt.show()

    return df_train, df_test