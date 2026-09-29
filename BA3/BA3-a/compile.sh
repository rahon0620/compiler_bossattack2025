#!/bin/bash
mkdir -p build
cd build
bison -d ../main.y 
gcc -lm -c -g -I.. main.tab.c
flex -o main.yy.c ../main.l
gcc -lm -c -g -I.. main.yy.c
gcc -Wall -O2 -o main main.tab.o main.yy.o -lfl -lm
