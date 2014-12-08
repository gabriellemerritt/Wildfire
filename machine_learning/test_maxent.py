import numpy as np  
import csv 
import nltk.classify.util 
from nltk.classify import MaxentClassifier
from sklearn.linear_model import LogisticRegression
from numpy import genfromtxt 
from sklearn.metrics import accuracy_score
from sklearn import preprocessing

data = genfromtxt('data_array.csv', delimiter=',')
X = data[:-1,:-1]
y = data[:-1, -1]
n, d = X.shape
nTrain = 0.5*n 
idx = np.arange(n)
np.random.seed(13)
np.random.shuffle(idx)
X = X[idx]
y = y[idx]

X = preprocessing.scale(X)
print np.isnan(X)
# split the data
Xtrain = X[:nTrain, :]
ytrain = y[:nTrain]
Xtest = X[nTrain:, :]
ytest = y[nTrain:]

print X.shape

lr = LogisticRegression();

lr = lr.fit(Xtrain,ytrain)

pred_lr = lr.predict(Xtest)

lr_acc = accuracy_score(ytest,pred_lr)

print lr_acc
print me_acc




