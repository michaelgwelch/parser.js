
all: hint test

.PHONY:	hint
hint:
	coffeelint *.coffee test/*.coffee

.PHONY: test
test:
	mocha --compilers coffee:coffee-script/register
