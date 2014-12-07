# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import Image
import numpy as np

vals = np.random.random_integers(0,3,58)
rdiff = 255/4


base = Image.open("county_cut__58.png")
base.load()
rb,gb,bb,ab = np.array(base).T

rv = 58

if(rv==0):
    rb[:,:]=255
    gb[:,:]=255
    bb[:,:]=255
if(rv!=0):
    rb[:,:]=rdiff*rv
    gb[:,:]=0
    bb[:,:]=0
im_paste = Image.fromarray(np.dstack([item.T for item in (rb,gb,bb,ab)]))

base = Image.fromarray(np.dstack([item.T for item in (rb,gb,bb,ab)]))
fil_end = ".png"

for i in range (1,58):
    if (i<10):
        fil_start = "county_cut__0";
    if (i>=10):
        fil_start = "county_cut__";
        
    rv = vals[i-1]        
        
    filename = fil_start+str(i)+fil_end;
    im_paste = Image.open(filename)
    im_paste.load()
    
    rp,gp,bp,ap = np.array(im_paste).T

    if(rv==0):
        rp[:,:]=255
        gp[:,:]=255
        bp[:,:]=255
    if(rv!=0):
        rp[:,:]=rdiff*rv
        gp[:,:]=0
        bp[:,:]=0
    im_paste = Image.fromarray(np.dstack([item.T for item in (rp,gp,bp,ap)]))
    
    base.paste(im_paste, (0,0),im_paste)
base.save("modified.png")


    
