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

  import Data.Aeson
  import Data.Text
  import Text.Megaparsec
  import Text.Mustache
  import qualified Data.Text.Lazy.IO as TIO

  import Data.List

  import System.Posix.Types
  import qualified System.Posix.Files as Files
  import System.FilePath.Find
  import System.Environment
  import Control.Monad
  import Data.Ord
  import System.Time.Utils

  import Language.Haskell.Interpreter
  import Control.Monad

  data Opts w = Opts
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

  instance ParseRecord (Opts Wrapped)
  deriving instance Show (Opts Unwrapped)

  data Evaluated = Evaluated {
    path:: FilePath,
    value:: EpochTime
    }

  instance Show Evaluated where
    show e = (show (epochToClockTime (value e))) ++ " " ++ (show (path e))

  instance Eq Evaluated where
    e1 == e2 = (value e1) == (value e2)

  instance Ord Evaluated where
    e1 `compare` e2 = (value e1) `compare` (value e2)

  type Metric = FileInfo -> EpochTime

  metric :: Metric
  metric = Files.modificationTime . infoStatus

  folding :: Int -> Metric -> [Evaluated] -> FileInfo -> [Evaluated]
  folding size metric previous info
    | accept || best > evaluated = insert evaluated previous
    | otherwise                  = previous
    where best = Data.List.head previous
          accept = Data.List.length previous < size
          evaluated = Evaluated {
            path=infoPath info,
            value=metric info
            }

  notHidden :: FindClause Bool
  notHidden = fileName /~? ".?*"

  testHint = do
    setImportsQ [("Prelude", Nothing)]
    let expr = "42"
    a <- eval expr
    say $ show a

  errorString :: InterpreterError -> String
  errorString (WontCompile es) = Data.List.intercalate "\n" (header : Data.List.map unbox es)
    where
      header = "ERROR: Won't compile:"
      unbox (GhcError e) = e
  errorString e = show e

  say :: String -> Interpreter ()
  say = liftIO . putStrLn

  emptyLine :: Interpreter ()
  emptyLine = say ""

  main :: IO ()
  main = do
    x <- unwrapRecord "hax"
    print (x :: Opts Unwrapped)
    let root = template x
    print (template x)
    results <- fold notHidden (folding 10 metric) [] root
    sequence $ Data.List.map print results
    let res = compileMustacheText "test"
          "[{{group}}]\nvalues:{{#values}}\n - {{.}}{{/values}}\n"
    case res of
      Left err -> putStrLn (parseErrorPretty err)
      Right template -> TIO.putStr $ renderMustache template $ object
        [ "group"   .= ("group1" :: Text)
        , "values" .= ["value1" :: Text, "value2", "value3"]
        ]
    r <- runInterpreter testHint
    case r of
      Left err -> putStrLn $ errorString err
      Right () -> return ()
    putStrLn "ok"

-- *EOF*
