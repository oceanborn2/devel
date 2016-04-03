SRCDIR=.
SRC=encrypt.cc options.cc utils.cc encryption_method.cc prime_numbers.cc
OBJ=encrypt.o options.o utils.o encryption_method.o prime_numbers.o
LINKFLAGS=-g -O2 -o encrypt
CC=c++

encrypt: ${OBJ}
	${CC} ${LINKFLAGS} ${OBJ}

.cc.o:
	${CC} -c -fhandle-exceptions $<

build:  clean encrypt
