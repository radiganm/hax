-- Main.hs
-- Copyright 2017 Mac Radigan
-- All Rights Reserved

{-- hax

Usage Statement:

   usage: hax [-h] [--verbose] [--generate] [--environment] [--force] [--include PATH] [--output PATH] --template PATH

   arguments:
     --template PATH        template file or directory

   optional arguments:
     -h, --help             show this help message and exit
     --output PATH          output directory
     --render               render to disk
     --environment          propagate user environment
     --force                force overwrite
     --include PATH         template include path
     --verbose              verbose output to stderr
     --generate FILE        generator source

Example Usage(s):

    ./hax --include ./demo/include --template ./demo/template/README.md --render
    ./hax --include ./demo/include --template ./demo/template/README.md --generate ./demo/pi.hs
    ./hax --include ./demo/include --template ./demo/template           --render
    ./hax --include ./demo/include --template ./demo/template           --generate ./demo/pi.hs

*** TODO:  short flag support (below) ***

Usage Statement:

   usage: hax [-h] [-v] [-g] [-e] [-f] [-I PATH] [-o PATH] -t PATH

   arguments:
     -t,--template PATH        template file or directory

   optional arguments:
     -h, --help                show this help message and exit
     -o,--output PATH          output directory
     -r,--render               render to disk
     -e,--environment          propagate user environment
     -f,--force                force overwrite
     -i,--include PATH         template include path
     -v,--verbose              verbose output to stderr
     -g,--generate FILE        generator source

Example Usage(s):

    ./hax -i ./demo/include -t ./demo/template/README.md -r
    ./hax -i ./demo/include -t ./demo/template/README.md -g ./demo/pi.hs
    ./hax -i ./demo/include -t ./demo/template           -r
    ./hax -i ./demo/include -t ./demo/template           -g ./demo/pi.hs

--}

  {-# LANGUAGE DataKinds          #-}
  {-# LANGUAGE DeriveGeneric      #-}
  {-# LANGUAGE FlexibleInstances  #-}
  {-# LANGUAGE OverloadedStrings  #-}
  {-# LANGUAGE StandaloneDeriving #-}
  {-# LANGUAGE TypeOperators      #-}

  module Main where

  import Hax
  import Options.Generic

  data Example w = Example
      { help        :: w ::: Bool         <?> "show this help message and exit"
      , output      :: w ::: Maybe String <?> "output directory"
      , render      :: w ::: Bool         <?> "render to disk"
      , environment :: w ::: Bool         <?> "propagate user environment"
      , force       :: w ::: Bool         <?> "force overwrite"
      , template    :: w ::: String       <?> "template path"
      , include     :: w ::: Maybe String <?> "template include path"
      , verbose     :: w ::: Bool         <?> "verbose output to stderr"
      , generate    :: w ::: Maybe String <?> "generator source"
      } deriving (Generic)

  instance ParseRecord (Example Wrapped)
  deriving instance Show (Example Unwrapped)

  main :: IO ()
  main = do
      x <- unwrapRecord "Test program"
      print (x :: Example Unwrapped)

-- *EOF*
