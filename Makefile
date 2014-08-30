
all: hint test

.PHONY:	hint
hint:
	jshint *.js test/*.js
.PHONY: test
test:
	mocha
