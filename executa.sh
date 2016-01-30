#!/bin/bash

clear
echo "Iniciando o trabalho:"
as trabalho.s -o trabalho.o
ld trabalho.o -l c -dynamic-linker /lib/ld-linux.so.2 -o trabalho
./trabalho
