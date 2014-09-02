expect = require "expect.js"
Maybe = require "../maybe.coffee"
Tuple = require "../tuple.coffee"
r = require "../regex.coffee"

describe "regex module", ->
  describe "charexpr", ->
    it "parses and returns a single char parser", ->
      expect(r.charexpr.parse("a").bind (tuple) -> tuple.unpack (parser,_) ->
        parser.parse("a")).eql(Maybe.just(new Tuple("a","")))

  describe "parenexpr", ->
    it "handles regexes with parens", ->
      expect(r.parenexpr.parse("(a)").bind (tuple) -> tuple.unpack (parser,_)->
        parser.parse("a")).eql(Maybe.just(new Tuple("a","")))

  describe "basicexpr", ->
    it "handles char", ->
      expect(r.basicexpr.parse("a").bind (tuple) -> tuple.unpack (parser,_) ->
        parser.parse("a")).eql(Maybe.just(new Tuple("a","")))

    it "handles paren", ->
      expect(r.basicexpr.parse("(a)").bind (tuple) -> tuple.unpack (parser,_) ->
        parser.parse("a")).eql(Maybe.just(new Tuple("a","")))

  describe "repeatexpr", ->
    it "handles regex with *", ->
      expect(r.repeatexpr.parse("a*").bind (tuple) -> tuple.unpack (parser,_) ->
        parser.parse("aaaab")).eql(Maybe.just(new Tuple("aaaa","b")))

    it "handles regex without *", ->
      expect(r.repeatexpr.parse("c").bind (tuple) -> tuple.unpack (parser,_) ->
        parser.parse("c")).eql(Maybe.just(new Tuple("c","")))

  describe "concatexpr", ->
    it "handles concatenated expressions", ->
      expect(r.concatexpr.parse("ab*").bind (tuple) -> tuple.unpack (parser,_)->
        parser.parse("abbbc")).eql(Maybe.just(new Tuple("abbb","c")))

  describe "orexpr", ->
    it "handle choice", ->
      expect(r.orexpr.parse("c|d").bind (tuple) -> tuple.unpack (parser,_) ->
        parser.parse("a")).eql(Maybe.nothing())
      expect(r.orexpr.parse("c|d").bind (tuple) -> tuple.unpack (parser,_) ->
        parser.parse("c")).eql(Maybe.just(new Tuple("c","")))
      expect(r.orexpr.parse("c|d").bind (tuple) -> tuple.unpack (parser,_) ->
        parser.parse("d")).eql(Maybe.just(new Tuple("d","")))

  describe "accepts", ->
    it "checks to see if a regex pattern accepts the given string", ->
      expect(r.accepts("","")).equal true
      expect(r.accepts("","anything")).equal false
      expect(r.accepts("2","2")).equal true
      expect(r.accepts("2", "2 ")).equal false
      expect(r.accepts("(z)","z")).equal true
      expect(r.accepts("(z)","(z)")).equal false
      expect(r.accepts("(ze)4","ze4")).equal true
      expect(r.accepts("(ze)4"," ze4 ")).equal false
      expect(r.accepts("(ze)*4","4")).equal true
      expect(r.accepts("(ze)*4", "ze4")).equal true
      expect(r.accepts("(ze)*4", "zezezeze4")).equal true
      expect(r.accepts("(ze)*4", "zeee4")).equal false
      expect(r.accepts("aaa", "a")).equal false
      expect(r.accepts("c|de*","deee")).equal true
      expect(r.accepts("c|de*","c")).equal true
