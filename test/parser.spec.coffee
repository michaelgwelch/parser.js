expect = require 'expect.js'
p = require('../parser.coffee')
assert = require 'assert'
Maybe = require '../maybe.js'
Tuple = require '../tuple.coffee'

nothing = Maybe.nothing()
just = Maybe.just
justTuple = (x,y) -> Maybe.just(new Tuple(x,y))

describe "parsers",  ->
  describe "failure", ->
    it "should never parse anything", ->
      expect(p.failure.parse("input")).eql(nothing)
      # TODO: Want a way to pass multiple inputs to failure

  describe "success", ->
    it "should parse whatever it is given without consuming any input", ->
      expect(p.success(34).parse("input")).eql(justTuple(34,"input"))

  describe "item", ->
    describe "it should parse one character", ->
      it "parses 'input' and returns ('i','nput')", ->
        expect(p.item.parse("input")).eql(justTuple("i","nput"))

      it "parses nothing if input is empty string", ->
        expect(p.item.parse("")).eql(nothing)

  describe "Parser#bind", ->
    it "allows us to combine parsers", ->
      onechar = p.item.bind (c1) -> p.success c1
      expect(onechar.parse("cat")).eql(justTuple("c","at"))

  is_c = (v) -> v is "c"

  describe "sat", ->
    it "parses if its predicate returns true for the next charater", ->
      expect((p.sat is_c).parse("cat")).eql(justTuple("c","at"))

    it "parses nothing if the predicate returns false", ->
      expect((p.sat is_c).parse("dog")).eql(nothing)

    it "parses nothing if the input is empty", ->
      expect((p.sat is_c).parse("")).eql(nothing)

  describe "lift", ->
    describe "lifts a function of type a -> b to Parser a -> Parser b", ->
      it "Can be used to turn item and parseInt into a parser of numbers", ->
        expect((p.lift(parseInt)(p.item)).parse("3")).eql(justTuple(3,""))

  describe "lift2", ->
    describe "lifts f:a -> b -> c to Parser a -> Parser b -> Parser c", ->
      it "Can do this:", ->
        adder = (f) -> (s) -> (parseInt f) + (parseInt s)
        expect((p.lift2(adder)(p.item)(p.item)).parse("34"))
          .eql(justTuple(7,""))

  describe "string", ->
    it "parses empty string if expected empty string", ->
      expect(p.string("").parse("")).eql(justTuple("",""))

    it "parses the specified string", ->
      expect(p.string("hello").parse("hello, there"))
        .eql(justTuple("hello", ", there"))

    it "parses nothing if the input prefix doesn't match the expected", ->
      expect(p.string("aa").parse("a")).eql(nothing)

  describe "#or", ->
    it "attempts parsing with the first parser and if that fails " +
      "attemps parsing with the second parser", ->
      theParser = p.failure.or p.item
      expect(theParser.parse("hello")).eql(justTuple("h","ello"))

    it "another example", ->
      expect(p.item.or(p.success(23)).parse("")).eql(justTuple(23,""))
