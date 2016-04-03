# definition de la liste des fichiers sources
SRC=wexplode.cc ftutilities.cc forte.cc options.cc utility.cc filereader.cc display.cc 
OBJ=wexplode.o  ftutilities.o  forte.o  options.o  utility.o  filereader.o  display.o

# Regles concernant la compilation

CXX=c++

CPLUSPLUSCOMPILE=$(CXX) -o $@ $(OBJ) -I. -I$(COM) -I$(FRT) -lg++ 


PROG=wexplode

$(PROG)	: $(OBJ)
	$(CPLUSPLUSCOMPILE)

%.o:%.cc
	$(CXX) $(CXXFLAGS) -c $<  	

# Dependances
wexplode.o      : wexplode.cc
display.o     	: display.cc
options.o     	: options.cc 
utility.o	: utility.cc 
ftutilities.o	: ftutilities.cc 
forte.o	        : forte.cc 
filereader.o	: filereader.cc	





















