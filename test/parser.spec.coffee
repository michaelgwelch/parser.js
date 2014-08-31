should = require 'should'
p = require('../parser.coffee')
assert = require 'assert'
Maybe = require '../maybe.js'
Tuple = require '../tuple.coffee'

describe "parsers",  ->
  describe "failure", ->
    it "should never parse anything", ->
      p.failure.parse("input").ifJust(-> assert(false, "expected nothing"))
      # TODO: Want a way to pass multiple inputs to failure

  describe "success", ->
    it "should parse whatever it is given without consuming any input", ->
      p.success(34).parse("input").case(
        () -> assert(false, "Expected Just (34,'input'), got nothing."),
        (value) -> value.should.eql(new Tuple(34,"input"))
      )

  describe "item", ->
    describe "it should parse one character", ->
      it "parses 'input' and returns ('i','nput')", ->
        p.item.parse("input").case(
          () -> assert(false, "Expected Just ('i','nput'), got nothing")
          (value) -> value.should.be.eql(new Tuple("i","nput"))
        )

      it "parses noting if input is empty string", ->
        p.item.parse("").case(
          () ->
          (value) -> assert(false, "Expect nothing")
        )
