import numpy as np  
import csv 
import nltk.classify.util 
from nltk.classify import MaxentClassifier
from sklearn.linear_model import LogisticRegression
from numpy import genfromtxt 
 
if __name__ == "__main__":
    data_file = sys.argv[1]
    data = genfromtxt('data_array.csv', delimiter=',')
    X = data[:,:-1]
    y = data[:, -1]
    n, d = X.shape
    nTrain = 0.5*n 
    idx = np.arange(n)
    np.random.seed(13)
    np.random.shuffle(idx)
    X = X[idx]
    y = y[idx]
    # split the data
    Xtrain = X[:nTrain, :]
    ytrain = y[:nTrain]
    Xtest = X[nTrain:, :]
    ytest = y[nTrain:]


