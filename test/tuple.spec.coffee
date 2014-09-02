Tuple = require '../tuple.js'
should = require 'should'

describe "Tuple", ->
  describe "unpack", ->
    it "calls the callback with individual values of the tuple", ->
      new Tuple(3,"hello").unpack (x,str) ->
        x.should.equal 3
        str.should.equal "hello"

  describe "toString", ->
    it "new Tuple(3,4).toString() returns '(3,4)'", ->
      new Tuple(3,4).toString().should.equal "(3,4)"

  describe "first", ->
    it "extracts the first value from the tuple", ->
      new Tuple(5,7).first().should.equal 5

  describe "second", ->
    it "extracts the second value from the tuple", ->
      new Tuple(7,9).second().should.equal 9
