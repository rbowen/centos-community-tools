#!/usr/bin/python

# How many followers do you have?
import urllib.request
import re
from pprint import pprint


feeds = [
        'rbowen','centosproject','theasf','realDonaldTrump'
        ];
for feed in feeds:
    req = urllib.request.Request( 'https://twitter.com/' + feed + '/',
        data = None,
        headers={
            'User-Agent': 
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.47 Safari/537.36'
        }   )
    f = urllib.request.urlopen(req)

    print(f.read())
    html = f.read().decode('utf-8')
    print (html)

#  Looks like ...
#           <div class="statnum">2,615</div>
#           <div class="statlabel"> Followers </div>

    print ( feed + ': ' + re.search('.*?followers">.+?statnum">([\d,MK]+)</div>.*?<.*?statlabel"> Followers.*', html, re.DOTALL).group(1) )

