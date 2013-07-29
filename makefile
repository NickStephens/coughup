SRCS=Main.hs InvoiceSemantics.hs InvoiceParser.hs

OBJS=Main.hi InvoiceSemantics.hi InvoiceParser.hi Main.o InvoiceSemantics.o InvoiceParser.o

INSTALLDIR=/usr/bin

all: $(SRCS)
	ghc $(CFLAGS) -o coughup Main.hs

clean: $(OBJS)
	rm -f *.o *.hi coughup
 
install: coughup
	cp coughup $(INSTALLDIR)
