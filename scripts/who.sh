#!/bin/sh
# Who contributed (post-process output of rss_updates.py (Numbers are
# not reliable, as one person will invariably appear more than once in a
# given change, but it's a good way to get a list to start with.)

egrep '@' rss_updates.html | egrep ' GMT ' | sed 's/^.* GMT - //;' | sed 's/\&lt.*$//' | sort | uniq -c | sort -rn > who_contributed.txt

