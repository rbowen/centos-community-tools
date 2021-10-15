#!/usr/bin/python3
import sys
import urllib3
import sqlite3
import feedparser
import re

db_connection = sqlite3.connect('centos_update_rss.sqlite')
db = db_connection.cursor()

# Uncomment this line to start with a fresh database
# db.execute('DROP TABLE centosupdates')

db.execute('CREATE TABLE IF NOT EXISTS centosupdates (title TEXT, id TEXT)')
out  = open('rss_updates.txt', 'w')
html = open('rss_updates.html', 'w')

def read_release_feed():
    """ Get packages from RSS feed """
    feedbase = 'https://feeds.centos.org/';
    feeds = [

            # 8-x86-64
            'centos-8-x86_64-BaseOS',
            'centos-8-x86_64-AppStream',
            'centos-8-x86_64-PowerTools',
            'centos-8-x86_64-centosplus',
            'centos-8-x86_64-cr',

            # 8 everything else
            'centos-8-aarch64-BaseOS',
            'centos-8-aarch64-AppStream',
            'centos-8-aarch64-PowerTools',
            'centos-8-aarch64-centosplus',
            'centos-8-aarch64-cr',
            'centos-8-ppc64le-AppStream',
            'centos-8-ppc64le-BaseOS',
            'centos-8-ppc64le-PowerTools',
            'centos-8-ppc64le-centosplus',
            'centos-8-ppc64le-cr',

            # Stream
            'centos-8-stream-aarch64-BaseOS',
            'centos-8-stream-aarch64-AppStream',
            'centos-8-stream-aarch64-PowerTools',
            'centos-8-stream-ppc64le-AppStream',
            'centos-8-stream-ppc64le-BaseOS',
            'centos-8-stream-ppc64le-PowerTools',
            'centos-8-stream-x86_64-AppStream',
            'centos-8-stream-x86_64-BaseOS',
            'centos-8-stream-x86_64-PowerTools'

            ]

    # HTML headers
    html.write("<ul>\n");
    for f in feeds:
        html.write("<li><a href='#" + f + "'>" + f + "</a></li>\n");
    html.write("</ul>\n");

    for f in feeds:
        count = 0
        feed = feedparser.parse(feedbase + f + '.xml')
        print("Checking new packages in " + f + "                         ", end="\r")
        out.write("\n\nNew packages in " + f + ":")
        html.write("<a name='" + f + "'><h2>New packages in " + f + "</h2></a>")

        for release in feed['entries']:
            if release_is_not_db(release['title'], release['id']):
                format_release(release)
                add_release_to_db(release['title'], release['id'])
                count += 1

        if (count == 0):
            msg = "No new packages in " + f  + " since last scan."
            out.write("\n" + msg + "\n\n")
            html.write("<p>" + msg + "</p>\n")

    print("See rss_updates.txt and rss_updates.html for results                                           \n")

def release_is_not_db(release_title, release_id):
    """ Check if we've already seen a release
    Args:
        release_title (str): Title
        release_id (str): Unique ID of release
    Return:
        True if we haven't seen it yet
        False otherwise
    """
    db.execute("SELECT * from centosupdates WHERE title=? AND id=?", (release_title, release_id))
    if not db.fetchall():
        return True
    else:
        return False


def add_release_to_db(release_title, release_id):
    """ Add a new release to the database
    Args:
        release_title (str): The title of a release
        release_id (str): Unique ID of release
    """

    db.execute("INSERT INTO centosupdates VALUES (?, ?)", (release_title, release_id))
    db_connection.commit()


def format_release( release ):
    """ Prettyprint the release info """
    out.write("\n" + release['published'] + ": " + release['title'])
    html.write("\n<h3>" + release['published'] + ": " + release['title'] + "</h3>")

    """ Strip HTML, special chars """
    summary = re.sub('<[^<]+?>', '', release['summary'])
    summary = re.sub('&lt;', '<', summary)
    summary = re.sub('&gt;', '>', summary)

    """ Drop everything past the first (most recent) Change Log: entry """
    summary = re.sub('(Change Log:\n\n.*?)\n\n.*$', r'\1', summary, flags=re.S)

    html.write(release['summary'])
    html.write("\n\n")
    print(".", end ="", flush=True)

if __name__ == '__main__':

    read_release_feed()
    db_connection.close()
    out.close()
    html.close()

