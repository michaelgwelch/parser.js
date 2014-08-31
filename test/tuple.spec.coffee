Tuple = require '../tuple.coffee'
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
