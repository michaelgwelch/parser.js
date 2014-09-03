
all: hint test

.PHONY:	hint
hint:
	jshint *.js test/*.js
	coffeelint test/*.coffee

.PHONY: test
test:
	mocha --compilers coffee:coffee-script/register
