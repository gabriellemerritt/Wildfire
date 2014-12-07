import csv
import json 
import numpy 
from numpy import genfromtxt
import urllib2
import sys

if __name__ == "__main__":
    file_county_data = sys.argv[1]
    file_dates = sys.argv[2] 
    file_outfile = sys.argv[3]

    outfile = open(file_outfile, 'wb')
    wrt = csv.writer(outfile,quoting =csv.QUOTE_ALL)

    with open(file_county_data, 'rU') as f:
        reader = csv.reader(f, quotechar='"', delimiter=',')
        c_data = list(reader)

    with open(file_dates, 'rU') as e:
        reader = csv.reader(e, quotechar='"', delimiter=',')
        date_data = list(reader)

    for i in xrange(len(date_data)):
        match = [s for s in c_data if date_data[i][0] in s]
        wrt.writerow(match[0])

    outfile.close()
    
