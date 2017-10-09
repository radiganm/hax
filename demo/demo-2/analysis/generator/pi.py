## pi.py
## Mac Radigan

from os.path import join, splitext
from os import walk, system
from collections import OrderedDict

K   = 10
datasets = [ ("dataset-%03d" % n) for n in range(0,K) ]

dataout = "../../demo-out/demo-2"
source  = "%s/simulation" % dataout
dest    = "%s/analysis"   % dataout
script = './report.sh'

for root, dirs, files in walk(source, topdown=True, onerror=None, followlinks=True):
  for filename in files:
    datafile = join(root, filename)
    case = splitext(filename)[0]
    for dataset in datasets:
      apply_templates()

system("(cd %s; chmod 775 %s && %s)" % (dest, script, script))

## *EOF*
