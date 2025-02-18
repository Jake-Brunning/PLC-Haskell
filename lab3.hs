module Main where
import System.IO
import Control.Monad
import Tokens
import Grammar
import System.Environment (getArgs)

main :: IO ()
main = task1

readFileToString :: FilePath -> IO String
readFileToString path = do
    handle <- openFile path ReadMode
    contents <- hGetContents handle
    return contents

task1 = do
        args <- getArgs
        code <- readFileToString (head args)
        print $ parseCalc $ alexScanTokens code