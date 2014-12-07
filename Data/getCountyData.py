import csv
import json 
import numpy 
from numpy import genfromtxt
import urllib2

lis = [] 
coords = genfromtxt('coords1.csv', delimiter=',')
myfile = open('1countreg.csv', 'wb')
wr = csv.writer(myfile, quoting = csv.QUOTE_ALL)
for i in xrange(len(coords)):
	response = urllib2.urlopen('http://data.fcc.gov/api/block/find?format=json&latitude=%f&longitude=%f' %(coords[i,0],coords[i,1]))
	data = json.load(response)
	wr.writerow([data['County']['name']])

myfile.close()
