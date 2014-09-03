
all: hint test

.PHONY:	hint
hint:
	jshint *.js
	coffeelint test/*.coffee

.PHONY: test
test:
	mocha --compilers coffee:coffee-script/register
