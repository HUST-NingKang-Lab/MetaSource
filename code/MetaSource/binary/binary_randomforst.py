import pandas
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.model_selection import GridSearchCV


##data input and data cleaning
data = pandas.read_csv("binary_classification.csv")

X = data.drop(columns=["biome", "pfam"]).fillna(0)
y = data['biome'].map({"others":1}).fillna(0).astype(int)

# print the number of features 
print(y.value_counts())

# data split,80% data was used as traning data and 20% data was used as testing data 
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# random forest classification
clf = RandomForestClassifier(n_estimators=10, max_depth=1, random_state=0,  class_weight={1:1, 0:2})
clf.fit(X_train, y_train)
acc = sum(y_test == clf.predict(X_test)) / len(y_test)
print("Acc:", acc)

# parameter tarning:using grid search to find the combination of parameters which could distinguish different samples accurately as much as possible

param_grid = {
    'n_estimators': [i*10 for i in range(1,20)],
    'criterion':['entropy', 'entropy'],
    'max_depth': [i for i in range(1, 10)],
    'max_features': ["auto", "log2"],
    'class_weight':[{1:1, 0:i} for i in range(1,5)]
}
clf = RandomForestClassifier()
grid_search = GridSearchCV(estimator=clf, 
                           param_grid=param_grid,
                           cv = 3,
                           n_jobs = -1,
                           verbose = 2)

grid_search.fit(X, y)
print(grid_search.best_params_)

# print the best combination of parameters
print(grid_search.best_score_)