#!/bin/bash

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
KOHAI= $(current_dir:.d=)


CC=g++-mp-4.8
ICC=icc
OBJECTS=kohai.cpp
CXFLAGS-GP=-std=c++11 -pthread -O3 -march=corei7 -msse4.2 --param max-inline-insns-auto=600 --param inline-min-speedup=5 -funsafe-loop-optimizations -funroll-loops -fno-rtti -pthread -fprofile-generate
CXFLAGS-GR=-std=c++11 -pthread -O3 -march=corei7 -msse4.2 --param max-inline-insns-auto=600 --param inline-min-speedup=5  -funsafe-loop-optimizations -funroll-loops -fno-rtti -pthread -fprofile-use
CXFLAGS-IP=-std=c++11 -march=corei7 -xSSE4.2 -finline-functions  -funroll-loops -fno-rtti -pthread -prof_gen
CXFLAGS-IR=-std=c++11 -ipo -march=corei7 -xSSE4.2 -finline-functions  -funroll-loops -fno-rtti -pthread -prof_use
STRIP=strip

#--param max-inline-insns-auto=100 --param inline-min-speedup=25

clean:
	rm -f *.o *.gcda *.dyn

g-pro:
	$(clean)
	$(CC) $(CXFLAGS-GP) $(OBJECTS) -o $(KOHAI)


g-rel:
	$(CC) $(CXFLAGS-GR) $(OBJECTS) -o $(KOHAI)
	$(STRIP) $(KOHAI)
	upx2 --lzma $(KOHAI)

i-pro:
	rm -f *.dyn
	$(ICC) $(CXFLAGS-IP) $(OBJECTS) -o $(KOHAI)

i-rel:
	$(ICC) $(CXFLAGS-IR) $(OBJECTS) -o $(KOHAI)
	$(STRIP) $(KOHAI)
	upx2 --lzma $(KOHAI)

