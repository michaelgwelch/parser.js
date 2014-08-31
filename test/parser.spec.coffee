should = require 'should'
p = require('../parser.coffee')
assert = require 'assert'

describe "parsers",  ->
  describe "failure", ->
    it "should never parse anything", ->
      p.failure.parse("input").ifJust(-> assert.fail("expect nothing"))
