module InvoiceSemantics where

import InvoiceParser hiding (main)
import Data.Time
import System.Locale
import Text.ParserCombinators.Parsec

{- Converts invoice datatypes to latex semantics -}

main file = do
    f <- parseFromFile invoice file
    case f of
        Left err -> print err
        Right inv -> print $ invoiceToTex inv

invoiceToTex (Invoice employee place streetaddr 
    email phonenum rate period shifts) =
    invoicePreamble ++
    (invoiceHeading place streetaddr phonenum email employee) ++
    (test shifts rate)

test shifts i = invoiceTable (zip shifts (gen i (length shifts)))

--test shifts rate = invoiceTable (zip shifts (gen rate (length shifts)))

invoicePreamble = 
    "\\documentclass[11pt]{invoice}" ++
    "\\ \\tab {\\hspace*{3ex}}" ++
    "\\begin{document}" 

invoiceHeading place address phonenum email employee = 
    "\\hfil{\\Huge\\bf" ++ place ++ "}\\hfil % Company providing the invoice" ++
    "\\bigskip\\break % Whitespace" ++
    "\\hrule % Horizontal line" ++
    address ++ "\\hfill " ++ phonenum ++ "\\\\ % Your address and contact information" ++
    "\\hfill " ++ email ++
    "\\\\ \\\\" ++
    "{\\bf Invoice To:} \\\\" ++
    "\\tab " ++ employee ++ "\\\\ % Invoice recipient" ++
    "{\\bf Date:} \\\\" ++
    "\\tab \\today \\\\ % Invoice date"

invoiceTable shifts = 
    "\\begin{invoiceTable}" ++ 
    "\\feetype{Consulting Services}" ++ 
    (concat $ map (uncurry toTexTableEntry) shifts) ++ 
    "\\end{invoiceTable}"
     
toTexTableEntry (Shift day period) rate = "\\hourrow{" ++ (show day) ++ "}{" ++ 
    (show $ hoursWorked period) ++ "}{" ++ (show rate) ++ "}"
    where hoursWorked (HourPeriod date1 date2) = diffDate date1 date2

--diffDate :: Fractional a => TimeOfDay -> TimeOfDay -> a

diffDate (TimeOfDay ehour emin esec) (TimeOfDay lhour lmin lsec)  = (fromIntegral (lhour - ehour)) + 
    ((fromIntegral $ lmin - emin) / 60)

gen _ 0 = []
gen n m = n: gen n (m-1)
