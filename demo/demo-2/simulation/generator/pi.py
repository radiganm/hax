## pi.py
## Mac Radigan

from collections import OrderedDict
from math import floor

mu  = 1.0
sig = 2.0
N   = 20
M   = int(N/4.0)

taps = [ 'source', 'filter_1', 'filter_2', 'sink' ]

hosts = [ "host-%d" % n for n in range(0,5) ]

paramAs = [ n for n in range(0,2) ]
paramBs = [ n for n in range(0,2) ]
paramCs = [ n for n in range(0,2) ]

K   = 10
datasets = [ ("dataset-%03d" % n) for n in range(0,K) ]

for dataset in datasets:
  for tap in taps:
    for paramA in paramAs:
      for paramB in paramBs:
        for paramC in paramCs:
          params = "paramA_%s-paramB_%s-paramC_%s" % (paramA, paramB, paramC)
          apply_templates()

## *EOF*
