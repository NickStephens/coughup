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
        Right inv -> writeFile output (invoiceToTex inv)
        where output = (times init 4 file) ++ ".tex"
              times f 0 x = x
              times f n x = f (times f (n-1) x)
          

invoiceToTex (Invoice employee place streetaddr 
    email phonenum rate period shifts) =
    invoicePreamble ++
    (invoiceHeading place streetaddr phonenum email employee) ++
    (test shifts rate) ++
    "\\end{document}"

test shifts i = invoiceTable (zip shifts (gen i (length shifts)))

--test shifts rate = invoiceTable (zip shifts (gen rate (length shifts)))

invoicePreamble = 
    "\\documentclass[11pt]{invoice}\n" ++
    "\\def \\tab {\\hspace*{3ex}}\n" ++
    "\\begin{document}\n" 

invoiceHeading place address phonenum email employee = 
    let (street, rest) = (\x -> x /= ',') `span` address in
    "\\hfil{\\Huge\\bf " ++ place ++ "}\\hfil % Company providing the invoice\n" ++
    "\\bigskip\\break % Whitespace\n" ++
    "\\hrule % Horizontal line\n" ++
    street ++ ",\\hfill " ++ phonenum ++ "\\\\ % Your address and contact information\n" ++
    (tail rest) ++ "\\hfill " ++ email ++
    "\\\\ \\\\\n" ++
    "{\\bf Invoice To:} \\\\\n" ++
    "\\tab " ++ employee ++ "\\\\ % Invoice recipient\n" ++
    "{\\bf Date:} \\\\\n" ++
    "\\tab \\today \\\\ % Invoice date\n"

invoiceTable shifts = 
    "\\begin{invoiceTable}\n" ++ 
    "\\feetype{Consulting Services}\n" ++ 
    (concat $ map (uncurry toTexTableEntry) shifts) ++ 
    "\\subtotal\n" ++
    "\\end{invoiceTable}\n"

toTexTableEntry (Shift day period) rate = "\\hourrow{" ++ (show day) ++ "}{" ++ 
    (show $ hoursWorked period) ++ "}{" ++ (show rate) ++ "}"
    where hoursWorked (HourPeriod date1 date2) = diffDate date1 date2

--diffDate :: Fractional a => TimeOfDay -> TimeOfDay -> a

diffDate (TimeOfDay ehour emin esec) (TimeOfDay lhour lmin lsec)  = (fromIntegral (lhour - ehour)) + 
    ((fromIntegral $ lmin - emin) / 60)

gen _ 0 = []
gen n m = n: gen n (m-1)
