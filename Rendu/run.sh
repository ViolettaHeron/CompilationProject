#!/bin/bash

flex -o ANSI-C.c ANSI-C.l
bison -d cfe.y
gcc ANSI-C.c cfe.tab.c generation_code.c pkg-config --cflags --libs glib-2.0 -o mongcc
echo "" > a.tmp

for testfile in ./Tests/*.c; do
	echo $testfile
	cat $testfile > programme.tmp
	echo $testfile >> a.tmp
	./mongcc programme.tmp | grep -e -- >> a.tmp
done

rm programme.tmp
echo "___________________________________"
cat a.tmp

