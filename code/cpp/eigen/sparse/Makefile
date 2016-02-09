# Various flags
CXX  = g++
LINK = $(CXX)
#CXXFLAGS = -I -Wall -g 
CXXFLAGS = -I -Wall -O3 -funroll-loops -pipe
LFLAGS = -lm

TARGET  = peel

HEADER  = Graph.h
FILES = Graph.cpp Peel.cpp

OBJECTS = $(FILES:.cc=.o)

$(TARGET): ${OBJECTS}
	$(LINK) $^ $(LFLAGS) -o $@

all: $(TARGET)

clean:
	rm -f $(OBJECTS)

distclean:
	rm -f $(OBJECTS) $(TARGET)

# Compile and dependency
$(OBJECTS): $(HEADER) Makefile