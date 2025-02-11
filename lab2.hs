module Main where
import System.IO
import Control.Monad
import System.Environment (getArgs)
import Tokens

-- Main function
main :: IO ()
main = task2

task2 :: IO ()
task2 = do
    args <- getArgs --gets arguments
    code <- readFile (head args) --reads file
    putStrLn $ unlines $ map show $ alexScanTokens code --prints tokens as string


task1 :: IO ()
task1 = do
    args <- getArgs --gets arguments
    code <- readFile (head args) --reads file
    let tokens = alexScanTokens code --scans tokens
    print tokens --prints tokens