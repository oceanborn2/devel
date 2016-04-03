# Regles concernant les chemins d'acces aux fichiers

TOPDIR=$(HOME)/devel/
COM=$(TOPDIR)common/
FRT=$(TOPDIR)forte/


# Regles concernant la compilation

CXX=c++
#%.o: %.cc
	$(CXX) $(CXXFLAGS) -c $<  -O3

CPLUSPLUSCOMPILE=$(CXX) -o $@ $(OBJ) -lg++ -O3 














