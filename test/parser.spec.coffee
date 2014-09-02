expect = require 'expect.js'
p = require('../parser.coffee')
assert = require 'assert'
Maybe = require '../maybe.js'
Tuple = require '../tuple.coffee'

nothing = Maybe.nothing()
just = Maybe.just
justTuple = (x,y) -> Maybe.just(new Tuple(x,y))

describe "Parser",  ->
  describe ".failure", ->
    it "should never parse anything", ->
      expect(p.failure.parse("input")).eql(nothing)
      # TODO: Want a way to pass multiple inputs to failure

  describe ".success", ->
    it "should parse whatever it is given without consuming any input", ->
      expect(p.success(34).parse("input")).eql(justTuple(34,"input"))

  describe ".item", ->
    describe "it should parse one character", ->
      it "parses 'input' and returns ('i','nput')", ->
        expect(p.item.parse("input")).eql(justTuple("i","nput"))

      it "parses nothing if input is empty string", ->
        expect(p.item.parse("")).eql(nothing)

  describe "#bind", ->
    it "allows us to combine parsers", ->
      onechar = p.item.bind (c1) -> p.success c1
      expect(onechar.parse("cat")).eql(justTuple("c","at"))

  is_c = (v) -> v is "c"

  describe ".sat", ->
    it "parses if its predicate returns true for the next charater", ->
      expect((p.sat is_c).parse("cat")).eql(justTuple("c","at"))

    it "parses nothing if the predicate returns false", ->
      expect((p.sat is_c).parse("dog")).eql(nothing)

    it "parses nothing if the input is empty", ->
      expect((p.sat is_c).parse("")).eql(nothing)

  describe "#lift", ->
    describe "lifts a function of type a -> b to Parser a -> Parser b", ->
      it "Can be used to turn item and parseInt into a parser of numbers", ->
        expect((p.item.lift(parseInt)).parse("3")).eql(justTuple(3,""))

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
      expect(p.failure.or(p.item).parse("hello")).eql(justTuple("h","ello"))

    it "another example", ->
      expect(p.item.or(p.success(23)).parse("")).eql(justTuple(23,""))

  # the following could be improved. The are more like sanity check tests
  describe ".lower", ->
    it "attempts to parse one lower case letter", ->
      expect(p.lower.parse("h")).eql justTuple "h",""
      expect(p.lower.parse(",")).eql nothing

  describe ".upper", ->
    it "attempts to parse one upper case letter", ->
      expect(p.upper.parse("H")).eql justTuple "H",""
      expect(p.upper.parse("h")).eql nothing

  describe ".letter", ->
    it "attempts to parse one letter", ->
      expect(p.letter.parse("z")).eql justTuple "z",""
      expect(p.letter.parse(",")).eql nothing

  describe ".digit", ->
    it "attempts to parse one digit", ->
      expect(p.digit.parse("3")).eql justTuple "3",""
      expect(p.digit.parse("a")).eql nothing

  describe ".alphaNum", ->
    it "attempts to parse one alpha numeric char", ->
      expect(p.alphaNum.parse("5")).eql justTuple "5",""
      expect(p.alphaNum.parse(".")).eql nothing

  describe ".many", ->
    describe "converts a 'Parser a' into a 'Parser [a]'", ->
      it "parsers 0 or more times using specified parser", ->
        expect(p.many(p.digit).parse("123H")).eql justTuple ["1","2","3"],"H"
        expect(p.many(p.digit).parse("H")).eql justTuple [],"H"

  describe ".many1", ->
    describe "converts a 'Parser a' into a 'Parser [a]'", ->
      it "parsers 1 or more times using specified parser", ->
        expect(p.many1(p.digit).parse("123H")).eql justTuple ["1","2","3"],"H"
        expect(p.many1(p.digit).parse("H")).eql nothing

  describe ".space", ->
    it "it consumes one or more whitespace chars and returns nothing", ->
      expect(p.space.parse("    h")).eql justTuple null, "h"

  describe ".ident", ->
    it "parses an identifier", ->
      expect(p.ident.parse("value1 = 3")).eql justTuple "value1"," = 3"

  describe ".nat", ->
    it "parses a natural number", ->
      expect(p.nat.parse("123h")).eql justTuple 123,"h"

  describe ".token", ->
    it "consumes whitespace, parses with given parser, and consumes ws", ->
      expect(p.token(p.nat).parse("  123  h")).eql justTuple 123,"h"

  describe ".identifier", ->
    it "parses an identifier, throwing away ws before and after", ->
      expect(p.identifier.parse(" \tvalue =123")).eql justTuple "value","=123"

  describe ".natural", ->
    it "parses a natural, throwing away white space before and after", ->
      expect(p.natural.parse(" 123\nh")).eql justTuple "123","h"

  describe ".symbol", ->
    it "parses given string, throwing away white space before and after", ->
      expect(p.symbol("value").parse("\n\tconst value  =123")).eql
      justTuple "const","value =123"

  describe ".map", ->
    it "works just like Haskell map (Functor map)", ->
      expect(p.digit.map((v) -> v * 2).parse("2")).eql justTuple 4,""

  describe ".concat", ->
    it "creates parser that concatenates results of two list parsers", ->
      expect(p.many(p.natural).concat(p.many(p.identifier)).parse(
        "123 246 369 value i j")).eql justTuple [123,246,369,"value","i","j"],""

  describe ".concats", ->
    it "creates parser that concatenates results of two string parsers", ->
      expect(p.manys(p.digit).concat(p.manys(p.lower)).parse(
        "123abc")).eql justTuple "123abc",""
