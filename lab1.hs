import System.IO
import Control.Monad
import System.Environment (getArgs)
import Control.Exception (handle)

zipL :: (Ord a) => ([a],[a]) -> [[a]]
zipL ([],[]) = []
zipL ([],(x:xs)) = [x] : zipL (xs, [])
zipL ((x:xs),[]) = [x] : zipL (xs, [])
zipL ((x:xs), (y:ys)) |length (x:xs) == length (y:ys) = [x,y] : zipL (xs, ys)
                      |otherwise = []


unzipL :: (Ord a) => [[a]] -> ([a],[a])
unzipL [] = ([],[])
unzipL x = (map head x, map last x)

multiZipL :: (Ord a) => [[a]] -> [[a]]
multiZipL [] = []
multiZipL xs = getFirst xs : multiZipL (removeEmpty (map tail xs))

--gets the first element of each list in a list of lists
getFirst :: (Ord a) => [[a]] -> [a]
getFirst [] = []
getFirst ([]:xs) = getFirst xs
getFirst (x:xs) = head x : getFirst xs

--removes empty lists
removeEmpty :: (Ord a) => [[a]] -> [[a]]
removeEmpty [] = []
removeEmpty (x:xs) | x == [] = removeEmpty xs
                   | otherwise = x : removeEmpty xs

--reads a file to string
getFile :: String -> IO String
getFile filename = readFile filename

--changes each line of comma seperated string to a integer list
commaStringToInt :: String -> [[Int]]
commaStringToInt xs = map (map readInt . words) (tail $ lines $ replaceCommasWithSpaces xs)

readInt :: String -> Int
readInt = read


--replaces all commas in a string with spaces
replaceCommasWithSpaces :: String -> String
replaceCommasWithSpaces xs = replaceCharInString ',' ' ' xs


--replaces a character in a string with another character
replaceCharInString :: Char -> Char -> String -> String
replaceCharInString a b xs = map (\x -> if x == a then b else x) xs

--mutlizipfile
multiZipF :: String -> String -> IO ()
multiZipF file1 file2 = do contents <- getFile file1
                           let ints =  multiZipL $ commaStringToInt contents
                           writeToFile file2 (show ints)


--entry point
main :: IO ()
main = do
    args <- getArgs --gets arguments from command line
    checkFiles (head args) (head (tail args)) --checks if files exist
    multiZipF (head args) (head (tail args)) --calls multiZipF with the first two arguments


--checks if files exist
checkFiles :: String -> String -> IO ()
checkFiles file1 file2 = do
    handle (\e -> handleError e) $ do
        contents1 <- getFile file1
        contents2 <- getFile file2
        putStrLn "Files exist"
    return ()


--handles errors
handleError :: IOError -> IO ()
handleError e = putStrLn ("Error " ++ show e)


--writes a string to a file
writeToFile :: String -> String -> IO ()
writeToFile filename xs = writeFile filename xs