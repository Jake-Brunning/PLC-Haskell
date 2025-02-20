{
module MDLGram where
import MDL
}

--MDL.x uses basic wrapper so should be chill

%name parseMDL
%tokentype { Token }
%error { parseError } --needs to be defined later
%token
    TokenInt     { TokenInt $$}
    Forward      { TokenForward }
    Back         { TokenBack }
    RotateLeft   { TokenRotateLeft }
    RotateRight  { TokenRotateRight }
    If           { TokenIf }
    Else         { TokenElse }
    Then         { TokenThen }
    End          { TokenEnd }
    Check        { TokenCheck }
    Chain          { TokenChain }

--parser declarations

%right Forward Back RotateLeft RotateRight
%%
Program : Seq { $1 } --program is a sequence of instructions

Seq : Seq Chain Exp { SeqCons $3 $1 } --sequence is an expression followed by a sequence
    | Exp  { SeqSingle $1 } --or just an expression
    | { SeqEmpty } --or nothing

Exp : Forward TokenInt { Forward $2 }
    | Back TokenInt { Back $2 }
    | RotateLeft { RotateLeft }
    | RotateRight { RotateRight }
    | If Exp Then Exp Else Exp End { If $2 $4 $6 }
    | Check TokenInt { Check $2 }
    | TokenInt { Int $1 }

{
--error message
parseError :: [Token] -> a
parseError xs = error $  "Error with: " ++ show (head xs) ++ " full list of tokens is: " ++  (foldl (++) "\n" $ map (\x -> show x ++ "\n") xs)

data Exp = Forward Int
         | Back Int
         | RotateLeft
         | RotateRight
         | If Exp Exp Exp
         | Check Int
         | Int Int
         deriving Show

data Seq = SeqCons Exp Seq
          | SeqSingle Exp
          | SeqEmpty 
         deriving Show

}


