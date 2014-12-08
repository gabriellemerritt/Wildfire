print(__doc__)

import numpy as np
from sklearn import datasets
import csv
import json 

filePath = "Income.txt"
file = open(filePath,'r')
countypop = np.genfromtxt(file, delimiter='	', skip_header=1, dtype=None)
print countypop

filePath = "countiesandyears.csv"
file = open(filePath,'r')
countiesandyears = np.genfromtxt(file, delimiter=',', skip_header=1, dtype=None)
#print countiesandyears

# Create dictionary of counties and population density
pdict = dict(zero=0)
for point in countypop:
	new = point[1]
	newkey = point[0]
	pdict.update([(newkey,new)])

# Open a new fil in which to write the unemployment rates
myfile = open('income.csv', 'wb')
wr = csv.writer(myfile, quoting = csv.QUOTE_ALL)

# Look up each instance using county to find corresponding population density
# Write the population density in a new row in the text file
for point in countiesandyears:
	rate = pdict[point[0]]
	wr.writerow([rate])

myfile.close()

	

