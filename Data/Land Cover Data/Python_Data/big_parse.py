import csv
import json 
import numpy 
from numpy import genfromtxt
import urllib2
import sys

if __name__ == "__main__":
    file_county_files = sys.argv[1]
    file_dates_files = sys.argv[2] 
    file_outfile = sys.argv[3]
    with open(file_county_files ,'rU') as k: 
        reader = csv.reader(k, quotechar='"', delimiter=',')
        county_files = list(reader)
    with open (file_dates_files, 'rU') as m: 
        reader = csv.reader(m, quotechar='"', delimiter=',')
        date_files = list(reader)

    outfile = open(file_outfile, 'wb')
    wrt = csv.writer(outfile,quoting =csv.QUOTE_ALL)
    for j in xrange(len(date_files)):

        with open(county_files[j][0], 'rU') as f:
            reader = csv.reader(f, quotechar='"', delimiter=',')
            c_data = list(reader)

        with open(date_files[j][0], 'rU') as e:
            reader = csv.reader(e, quotechar='"', delimiter=',')
            date_data = list(reader)

        for i in xrange(len(date_data)):
            match = [s for s in c_data if date_data[i][0] in s]
            wrt.writerow(match[0])

    outfile.close()
