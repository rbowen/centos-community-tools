#!/usr/bin/python

# How many followers do you have?
import urllib.request
import re

feeds = [
        'centosproject',
        ];
for feed in feeds:
    response = urllib.request.urlopen('https://twitter.com/' + feed)
    html = response.read().decode('utf-8')
    print ( feed + ': ' + re.search('.*?([\d,]+ Followers).*', html).group(1) )

