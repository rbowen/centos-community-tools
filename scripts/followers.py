#!/usr/bin/python

# How many followers do you have?
import urllib.request
import re

print ("This doesn't work any more because Twitter is actively preventing it. Sorry.")
quit()

feeds = [
        'rbowen','centosproject','centos'
        ];
for feed in feeds:
    req = urllib.request.Request( 'https://twitter.com/' + feed + '/',
        data = None,
        headers={
            'User-Agent': 
            'Mozilla/5.0 (Windows NT 6.1; Win64; x64)',
        }   )
    f = urllib.request.urlopen(req)
    html = f.read().decode('utf-8')

#  Looks like ...
#           <div class="statnum">2,615</div>
#           <div class="statlabel"> Followers </div>

    print ( feed + ': ' + re.search('.*?followers">.+?statnum">([\d,MK]+)</div>.*?<.*?statlabel"> Followers.*', html, re.DOTALL).group(1) )

