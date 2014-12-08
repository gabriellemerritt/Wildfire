import csv
import json 
import numpy 
from numpy import genfromtxt
import urllib2
import sys

if __name__ == "__main__":
    file_county_files = sys.argv[1]
    file_weather_files = sys.argv[2] 
    file_dates_all = sys.argv[3]
    file_holidays = sys.argv[4]
    file_outfile = sys.argv[5]

    with open(file_county_files ,'rU') as k: 
        reader = csv.reader(k, quotechar='"', delimiter=',')
        county_files = list(reader)
        
    with open (file_weather_files, 'rU') as m: 
        reader = csv.reader(m, quotechar='"', delimiter=',')
        weather_files = list(reader)

    with open(file_dates_all, 'rU') as l : 
    	reader = csv.reader(l, quotechar='"', delimiter=',')
    	dates_all = list(reader)

    with open(file_holidays, 'rU') as p: 
    	reader = csv.reader(p, quotechar='"', delimiter=',')
    	holidays = list(reader)

    outfile = open(file_outfile, 'wb')
    wrt = csv.writer(outfile,quoting =csv.QUOTE_ALL)
    for j in xrange(len(county_files)):
        print weather_files[j]

        with open(county_files[j][0], 'rU') as f:
            reader = csv.reader(f, quotechar='"', delimiter=',')
            c_data = list(reader)

        with open(weather_files[j][0], 'rU') as e:
            reader = csv.reader(e, quotechar='"', delimiter=',')
            weather_data = list(reader)

        for i in xrange(len(dates_all)):
            wrt.writerow([c_data[i], weather_data[i], holidays[i]])

    outfile.close()