from urllib2 import urlopen
import json
import sys

url = "https://api.github.com/repos/prompto/prompto-factory/releases/latest"
cnx = urlopen(url)
doc = json.loads(cnx.read())
sys.stdout.write(doc['tag_name'])
