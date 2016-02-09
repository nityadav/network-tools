####################################################
# Copyright 2010, 2011 Alois Schloegl 
# This is part of the NaN-toolbox - a statistics and machine learning toolbox for data with and without missing values. 
# http://pub.ist.ac.at/~schloegl/matlab/NaN/
####################################################

### modify directories according to your needs 

# Octave - global install  (e.g. from debian package)
OCTAVE_VERSION = 
INCOCTAVE = -I /usr/include/octave 
# Octave - local install (e.g. compiled from sources) 
OCTAVE_VERSION = -3.4.0
INCOCTAVE = -I /usr/local/include/octave$(OCTAVE_VERSION)/octave 

# Matlab configuration
MATLABDIR = /usr/local/MATLAB/R2010b
# comment the following line if you use MATLAB on 32-bit operating system
MEX_OPTION += -largeArrayDims

# Mingw crosscompiler: available at http://www.nongnu.org/mingw-cross-env/
CROSS   = $(HOME)/src/mingw-cross-env/usr/bin/i686-pc-mingw32-
# include directory for Win32-Matlab include
W32MAT_INC = $(HOME)/bin/Matlab/R2010/extern/include/
# path to GNUMEX libraries, available from here http://sourceforge.net/projects/gnumex/
GNUMEX  = $(HOME)/bin/gnumex
####################################################

CC  	= gcc
CXX 	= g++
CFLAGS 	= -fopenmp -Wall -Wconversion -O2 -fPIC 
OCTMEX	= mkoctfile$(OCTAVE_VERSION) --mex
RM      = rm

MEX_OPTION  += -lz -lgomp CC\#$(CXX) CXX\#$(CXX) CFLAGS\#"$(CFLAGS)" CXXFLAGS\#"$(CFLAGS)"
MATMEX      = $(MATLABDIR)/bin/mex $(MEX_OPTION)

PROGS = histo_mex.mex covm_mex.mex kth_element.mex sumskipnan_mex.mex str2array.mex train.mex svmtrain_mex.mex svmpredict_mex.mex xptopen.mex 

MEX_EXT = $(shell $(MATLABDIR)/bin/mexext)
octave: $(PROGS)
matlab: $(patsubst %.mex, %.$(MEX_EXT), $(PROGS))
mexw32 win32:  $(patsubst %.mex, %.mexw32, $(PROGS))
all:    octave matlab win32

$(PROGS): Makefile

#########################################################
#	Octave, MATLAB on Linux 
#########################################################
%.oct: %.cc
	mkoctfile$(OCTAVE_VERSION) $<

%.mex: %.cpp
	$(OCTMEX) $<  -lz -lgomp         ## Octave
%.$(MEX_EXT): %.cpp
	$(MATMEX) $<  -lz -lgomp      ## Matlab

svmtrain_mex.mex svmpredict_mex.mex:     svmtrain_mex.cpp svm.h svm.cpp svm_model_matlab.c
	$(CXX) $(CFLAGS) $(INCOCTAVE) -c svm.cpp
	$(CC)  $(CFLAGS) $(INCOCTAVE) -c svm_model_matlab.c
	env CC=$(CXX) $(OCTMEX) svmtrain_mex.cpp svm.o svm_model_matlab.o
	env CC=$(CXX) $(OCTMEX) svmpredict_mex.cpp svm.o svm_model_matlab.o

svmtrain_mex.$(MEX_EXT) svmpredict_mex.$(MEX_EXT):     svmtrain_mex.cpp svm.h svm.cpp svm_model_matlab.c
	$(CXX) $(CFLAGS) -I $(MATLABDIR)/extern/include -c svm.cpp
	$(CC) $(CFLAGS) -I $(MATLABDIR)/extern/include -c svm_model_matlab.c
	$(MATMEX) svmtrain_mex.cpp svm.o svm_model_matlab.o
	$(MATMEX) svmpredict_mex.cpp svm.o svm_model_matlab.o

train.$(MEX_EXT) predict.$(MEX_EXT): train.c linear.h tron.o linear.o linear_model_matlab.c
	$(CC) $(CFLAGS) -I $(MATLABDIR)/extern/include -c linear_model_matlab.c
	$(MATMEX)  -lblas train.c tron.o linear.o linear_model_matlab.o 
	#$(MATMEX) -lblas predict.c tron.o linear.o linear_model_matlab.o

train.mex predict.mex: train.c linear.h tron.o linear.o linear_model_matlab.c
	$(CC) $(CFLAGS) $(INCOCTAVE) -c linear_model_matlab.c
	env CC=$(CXX) $(OCTMEX) -lblas train.c tron.o linear.o linear_model_matlab.o
	#env CC=$(CXX) $(OCTMEX) -lblas predict.c tron.o linear.o linear_model_matlab.o

linear.o: linear.cpp linear.h
	$(CXX) $(CFLAGS) -c linear.cpp

tron.o: tron.cpp tron.h
	$(CXX) $(CFLAGS) -c tron.cpp


clean: ; -$(RM) *.o core octave-core *.oct *~ *.mex*

#########################################################
#	MATLAB/WIN32
#########################################################
%.obj: %.cpp
	$(CROSS)$(CXX) -fopenmp -c -DMATLAB_MEX_FILE -x c++ -o $@ -I$(W32MAT_INC) -O2 -DMX_COMPAT_32 $<
%.obj: %.c
	$(CROSS)$(CXX) -fopenmp -c -DMATLAB_MEX_FILE -x c++ -o $@ -I$(W32MAT_INC) -O2 -DMX_COMPAT_32 $< 
#%.obj: LAPACK/%.f
#	$(CROSS)$(CXX) -c -DMATLAB_MEX_FILE -o$@ -I$(W32MAT_INC) -O3 -DMX_COMPAT_32 $< 

train.mexw32 predict.mexw32:  train.obj linear.obj linear_model_matlab.obj tron.obj
	$(CROSS)$(CXX) -shared $(GNUMEX)/mex.def -o $@ -L$(GNUMEX) -s $< linear_model_matlab.obj linear.obj tron.obj -llibmx -llibmex -llibmat -lz -lcholmod -lblas

svmpredict_mex.mexw32 :  svmpredict_mex.obj svm.obj svm_model_matlab.obj 
	$(CROSS)$(CXX) -shared $(GNUMEX)/mex.def -o $@ -L$(GNUMEX) -s $< svm_model_matlab.obj svm.obj -llibmx -llibmex -llibmat -lz -lcholmod
svmtrain_mex.mexw32 : svmtrain_mex.obj svm.obj svm_model_matlab.obj
	$(CROSS)$(CXX) -shared $(GNUMEX)/mex.def -o $@ -L$(GNUMEX) -s $< svm_model_matlab.obj svm.obj -llibmx -llibmex -llibmat -lz -lcholmod

%.mexw32: %.obj
	$(CROSS)$(CXX) -shared $(GNUMEX)/mex.def -o $@ -L$(GNUMEX) -s $< -llibmx -llibmex -llibmat -lz -lcholmod -lgomp -lpthread

clean:
	-$(RM) *.o *.obj core octave-core *.oct *~ *.mex*



