
all: hint test

.PHONY:	hint
hint:
	jshint test/*.js
	coffeelint *.coffee test/*.coffee

.PHONY: test
test:
	mocha --compilers coffee:coffee-script/register
