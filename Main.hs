module Main where

import InvoiceParser
import InvoiceSemantics
import System.Environment (getArgs)
import Text.ParserCombinators.Parsec

{- Parse a raw invoice file and produce a invoice tex file -}

main = do
    args <- getArgs
    let file = head args
    let output = (times init 4 file) ++ ".tex"
    f <- parseFromFile invoice file
    case f of
        Left err -> print err
        Right inv -> writeFile output (invoiceToTex inv)
        where times f 0 x = x
              times f n x = f (times f (n-1) x)
