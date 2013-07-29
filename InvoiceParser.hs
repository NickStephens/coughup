module InvoiceParser where

import Text.ParserCombinators.Parsec
import Data.Time
import System.Locale


data LHeader = LHeader LStatement

data LBody = LBody [LStatement]

data LFooter = LFooter LStatement

{- A Latex Statement -}
data LStatement = LStatement String

data Invoice = Invoice { employee :: String, placeOfEmployment :: String, address :: String, 
    email :: String, phonenum :: String, rateOfPay :: Int, period :: DatePeriod, shifts :: [Shift] }
    deriving Show

-- This is just cosmetic for now
data DatePeriod = DatePeriod Day Day
    deriving (Show, Eq)

-- When we automate weekend discovery you can discover a weekend by 
-- moding the integer which is the day 

data HourPeriod = HourPeriod TimeOfDay TimeOfDay
    deriving (Show, Eq)

data Shift = Shift Day HourPeriod
    deriving (Show, Eq)

main file = do
    f <- parseFromFile invoice file
    case f of
        Left err -> print err
        Right inv -> print inv

invoice = do
        employee <- name
        many1 space
        place <- name
        many1 space
        addr <- name  
        many1 space
        email <- name
        many1 space
        phonenum <- name
        many1 space
        rateOfPay <- rate
        many1 space
        period <- datePeriod
        many1 space
        shifts <- shift `endBy` (many space)
        return $ Invoice employee place addr email phonenum (read rateOfPay :: Int) period shifts
    
name :: Parser String
name = do
        char ':'
        many space
        yourName <- manyTill anyChar (try (char ':'))
        return yourName 

datePeriod = do 
        char '&'
        many space
        dateOne <- date
        many space
        char '-'
        many space
        dateTwo <- date
        many space
        char '&'
        return $ DatePeriod dateOne dateTwo

rate :: Parser String
rate = do
        char '%'
        many space
        try (char '$')
        many space
        myRate <- many1 digit
        many space
        char '%'
        return myRate

shift = do
        char '$'
        shiftDate <- date
        char '$'
        periods <- hourPeriod
        char '$'
        return $ Shift shiftDate periods
         
{-
comment = do
        many1 space
        char '#'
-}

{- INTERMEDIATE PARSING -}

hourPeriod = do
        started <- timeOfDay
        many space
        char '-'
        many space
        finished <- timeOfDay
        return $ HourPeriod (time started) (time finished)

timeOfDay :: Parser String
timeOfDay = do
        hour <- many1 digit
        char ':'
        minute <- many1 digit
        half <- (string "am" <|> string "pm")
        return (hour ++ ":" ++ minute ++ half)

date :: Parser Day
date = do
        month <- many1 digit
        char '/'
        day <- many1 digit
        char '/'
        year <- many1 digit
        return $ fromGregorian (read year :: Integer)
            (read month :: Int) (read day :: Int)

time = crack . time'
    where
    time' tm = parseTime defaultTimeLocale "%l:%M%P" tm :: Maybe TimeOfDay
    crack (Just t) = t
