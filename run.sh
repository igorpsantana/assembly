#!/bin/bash

clear
echo "Rodando:\n\n"
as trab.s -o trab.o
ld trab.o -l c -dynamic-linker /lib/ld-linux.so.2 -o trab
./trab
