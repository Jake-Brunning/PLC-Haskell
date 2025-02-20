module Main where
import System.IO
import Control.Monad
import Tokens
import Grammar
import MDLGram
import MDL
import System.Environment (getArgs)

main :: IO ()
main = task3

readFileToString :: FilePath -> IO String
readFileToString path = do
    handle <- openFile path ReadMode
    contents <- hGetContents handle
    return contents

task1 = do
        args <- getArgs
        code <- readFileToString (head args)
        print $ parseCalc $ Tokens.alexScanTokens code


task3 = do
        args <- getArgs
        code <- readFileToString (head args)
        let tokens = MDL.alexScanTokens code
        print tokens
        print $ parseMDL tokens