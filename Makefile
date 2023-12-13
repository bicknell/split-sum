
compiled_programs = split-sum-c \
                    target/release/split-sum \
                    split-sum-swift \
                    split-sum-objc \
                    split-sum-c++ \
                    splitSum.class \
                    split-sum-fortran

all: $(compiled_programs)

clean:
	rm -f split-sum-c split-sum-swift split-sum-objc split-sum-c++ splitSum.class split-sum-fortran
	rm -rf Cargo.lock target/

split-sum-c: split-sum.c
	cc -O3 -flto -o split-sum-c split-sum.c

target/release/split-sum: src/main.rs
	cargo build -r

split-sum-swift: split-sum.swift
	swiftc -O -o split-sum-swift split-sum.swift 

split-sum-objc: split-sum.m
	cc -ObjC -framework Foundation -O3 -o split-sum-objc split-sum.m

split-sum-c++: split-sum.cpp
	c++ -std=c++20 -O3 -o split-sum-c++ split-sum.cpp 

splitSum.class: splitSum.java
	javac splitSum.java

split-sum-fortran: split-sum.f90
	gfortran -O3 -o split-sum-fortran split-sum.f90

.SILENT: runall
runall: $(compiled_programs)
	printf -- "------------------\n"
	gfortran --version | head -1
	./split-sum-fortran
	printf -- "------------------\n"
	cc --version | head -1
	./split-sum-c
	printf -- "------------------\n"
	java -version 2>&1 | head -1
	java splitSum
	printf -- "------------------\n"
	go version
	go run split-sum.go
	printf -- "------------------\n"
	rustc --version
	target/release/split-sum
	printf -- "------------------\n"
	printf "JavaScript (node.js) version"
	node --version
	node split-sum.js
	printf -- "------------------\n"
	printf -- "TCL version "
	printf -- 'puts $$tcl_version' | tclsh
	tclsh split-sum.tcl
	printf -- "------------------\n"
	c++ --version | head -1
	./split-sum-c++
	printf -- "------------------\n"
	php --version | head -1
	php split-sum.php
	printf -- "------------------\n"
	swiftc --version 2>&1 | head -1
	./split-sum-swift
	printf -- "------------------\n"
	cc -ObjC --version | head -1
	./split-sum-objc
	printf -- "------------------\n"
	ruby --version
	ruby split-sum.rb
	printf -- "------------------\n"
	python3 --version
	python3 split-sum.py
	printf -- "------------------\n"
	perl --version | head -2 | tail -1
	perl split-sum.pl
	printf -- "------------------\n"
	r --version | head -1
	r --no-save --no-echo -f split-sum.r
	printf -- "------------------\n"
	psql --version
	psql -q -t -f split-sum-create.sql
	psql -c '\timing' -q -t -f split-sum-query.sql | sed -e 's/^.*:/sql: /' -e 's/)/ seconds/'
	printf -- "------------------\n"
	clisp --version | head -1
	clisp split-sum.lsp
	printf -- "------------------\n"
	zsh --version
	zsh split-sum.zsh
	printf -- "------------------\n"
	bash --version | head -1
	bash split-sum.sh
	
