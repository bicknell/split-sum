
compiled_programs = split-sum-c \
                    target/release/split-sum \
                    split-sum-swift \
                    split-sum-objc \
                    split-sum-c++ \
                    splitSum.class

all: $(compiled_programs)

clean:
	rm -f split-sum-c split-sum-swift split-sum-objc split-sum-c++ splitSum.class
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

runall: $(compiled_programs)
	@python3 --version
	python3 split-sum.py
	@printf -- "------------------\n"
	@perl --version | head -2 | tail -1
	perl split-sum.pl
	@printf -- "------------------\n"
	@go version
	go run split-sum.go
	@printf -- "------------------\n"
	@printf -- "TCL version "
	@printf -- 'puts $$tcl_version' | tclsh
	tclsh split-sum.tcl
	@printf -- "------------------\n"
	@ruby --version
	ruby split-sum.rb
	@printf -- "------------------\n"
	@node --version
	node split-sum.js
	@printf -- "------------------\n"
	@bash --version | head -1
	bash split-sum.sh
	@printf -- "------------------\n"
	@zsh --version
	zsh split-sum.zsh
	@printf -- "------------------\n"
	@cc --version | head -1
	./split-sum-c
	@printf -- "------------------\n"
	@c++ --version | head -1
	./split-sum-c++
	@printf -- "------------------\n"
	@rustc --version
	target/release/split-sum
	@printf -- "------------------\n"
	@swiftc --version | head -1
	./split-sum-swift
	@printf -- "------------------\n"
	@cc -ObjC --version | head -1
	./split-sum-objc
	@printf -- "------------------\n"
	@java -version 2>&1 | head -1
	java splitSum
	@printf -- "------------------\n"
	@psql --version
	@psql -q -f split-sum-create.sql
	@psql -c '\timing' -q -t -f split-sum-query.sql | sed -e 's/^.*:/sql: /' -e 's/)//'
	
