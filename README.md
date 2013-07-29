CoughUp
-------

A simple language used to quickly generate LaTeX invoices.

### Grammar

Invoice &rarr; name companyname address email phonenumber rate period { shift }

name &rarr; ':' string ':'

companyname &rarr; name

address &rarr; name

email &rarr; name

phonenumber &rarr; name

rate &rarr; '%' [$] { digit } '%'

period &rarr; '&' month/day/year - month/day/year '&'

shift &rarr; '$' month/day/year '$' time (am|pm) - time (am|pm) '$'

#### Installation

* make all
* sudo make install

#### Dependencies
* TeXLive Core
* Parsec2
* Invoice template by Trey Hunner

![http://legacy.cs.uu.nl/daan/parsec.html](http://legacy.cs.uu.nl/daan/images/parsec.gif)
