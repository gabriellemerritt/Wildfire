import numpy as np
from sklearn import datasets
import csv
import json 

filePath = "countiesandyears.csv"
file = open(filePath,'r')
countiesandyears = np.genfromtxt(file, delimiter=',', skip_header=1, dtype=None)
#print countiesandyears

filePath = "Unemployment.csv"
file = open(filePath,'r')
unemployment = np.genfromtxt(file, skip_header=1, dtype=None, delimiter=',')
#print unemployment

filePath = "Income.txt"
file = open(filePath,'r')
income = np.genfromtxt(file, delimiter='	', skip_header=1, dtype=None)
#print income

filePath = "countypop.txt"
file = open(filePath,'r')
countypop = np.genfromtxt(file, delimiter='	', skip_header=1, dtype=None)
#print countypop

# Create dictionary of counties, years, and rates
udict = dict(zero=0)
for point in unemployment:
	new = [point[1], point[2], point[3], point[4], point[5], point[6], point[7], point[8], point[9], point[10]]
	newkey = point[0]
	udict.update([(newkey,new)])

idict = dict(zero=0)
for point in income:
	new = point[1]
	newkey = point[0]
	idict.update([(newkey, new)])

pdict = dict(zero=0)
for point in countypop:
	new = point[1]
	newkey = point[0]
	pdict.update([(newkey, new)])

print udict, idict, pdict

# Open a new file in which to write the unemployment rates
myfile = open('urates.csv', 'wb')
wr = csv.writer(myfile, quoting = csv.QUOTE_ALL)

# Look up each instance using county and year to find corresponding unemployment rate
# Write the unemployment rate in a new row in the text file
#urates = []
for point in countiesandyears:
	rate = udict[point[0]][point[1]-2004]
	#urates.append(rate)
	wr.writerow([rate])

myfile.close()

	

