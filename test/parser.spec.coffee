expect = require 'expect.js'
p = require('../parser.coffee')
assert = require 'assert'
Maybe = require '../maybe.js'
Tuple = require '../tuple.coffee'


describe "parsers",  ->
  describe "failure", ->
    it "should never parse anything", ->
      expect(p.failure.parse("input")).eql(Maybe.nothing())
      # TODO: Want a way to pass multiple inputs to failure

  describe "success", ->
    it "should parse whatever it is given without consuming any input", ->
      expect(p.success(34).parse("input")).eql(Maybe.just(new Tuple(34,"input")))

  describe "item", ->
    describe "it should parse one character", ->
      it "parses 'input' and returns ('i','nput')", ->
        expect(p.item.parse("input")).eql(Maybe.just(new Tuple("i","nput")))

      it "parses nothing if input is empty string", ->
        expect(p.item.parse("")).eql(Maybe.nothing())

  describe "Parser#bind", ->
    it "allows us to combine parsers", ->
      onechar = p.item.bind (c1) -> p.success c1
      expect(onechar.parse("cat")).eql(Maybe.just(new Tuple("c","at")))


  describe "sat", ->
    it "parses if its predicate returns true for the next charater", ->
      expect((p.sat (v) -> v is "c").parse("cat")).eql(Maybe.just(new Tuple("c","at")))

    it "parses nothing if the predicate returns false", ->
      expect((p.sat (v) -> v is "c").parse("dog")).eql(Maybe.nothing())

    it "parses nothing if the input is empty", ->
      expect((p.sat (v) -> v is "c").parse("")).eql(Maybe.nothing())
