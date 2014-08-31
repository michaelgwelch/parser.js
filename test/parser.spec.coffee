should = require 'should'
p = require('../parser.coffee')
assert = require 'assert'
Maybe = require '../maybe.js'
Tuple = require '../tuple.coffee'

parsesNothing = (maybe) ->
  maybe.case(
    () ->
    (value) -> assert(false, "Expected nothing.")
  )

parses = (expected, maybe) ->
  () -> assert(false, "Expected a just value, got nothing")
  (value) -> value.should.eql(expected)

describe "parsers",  ->
  describe "failure", ->
    it "should never parse anything", ->
      parsesNothing(p.failure.parse("input"))
      # TODO: Want a way to pass multiple inputs to failure

  describe "success", ->
    it "should parse whatever it is given without consuming any input", ->
      parses(new Tuple(34,"input"), p.success(34).parse("input"))

  describe "item", ->
    describe "it should parse one character", ->
      it "parses 'input' and returns ('i','nput')", ->
        parses(new Tuple("i","nput"), p.item.parse("input"))

      it "parses nothing if input is empty string", ->
        parsesNothing(p.item.parse(""))

  describe "sat", ->
    it "parses if its predicate returns true for the next charater", ->
      parses(new Tuple("c","at"), p.sat((v) -> v is "c").parse("cat"))

    it "parses nothing if the predicate returns false", ->
      parsesNothing(p.sat((v) -> v is "c").parse "dog")

    it "parses nothing if the input is empty", ->
      parsesNothing(p.sat((v) -> v is "c").parse "")
