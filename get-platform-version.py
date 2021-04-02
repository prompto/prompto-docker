from urllib2 import urlopen
import json
import sys

def getPlatformVersion():
    url = "https://api.github.com/repos/prompto/prompto-platform/releases/latest"
    cnx = urlopen(url)
    doc = json.loads(cnx.read())
    return doc['tag_name'][1:]

if __name__ == '__main__':
    sys.stdout.write(getPlatformVersion())