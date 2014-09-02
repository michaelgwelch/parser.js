
c = require "../char.coffee"
expect = require "expect.js"
_ = require "lodash"


# Creates an arrange of chars from start to end, inclusive
# start and end are expected to be single char strings.
charRange = (start,end) ->
  _.range(start.charCodeAt(0),end.charCodeAt(0)+1).map (v) ->
    String.fromCharCode v

ascii = charRange(String.fromCharCode(0),String.fromCharCode(128))

# alternate implementations of the functions I'm testing
lowerChars = charRange 'a','z'
upperChars = charRange 'A','Z'
letters = lowerChars.concat upperChars
digits = charRange '0','9'
alphaNums = letters.concat digits

isLower = (c) -> _.contains lowerChars, c
isUpper = (c) -> _.contains upperChars, c
isLetter = (c) -> _.contains letters, c
isDigit = (c) -> _.contains digits, c
isAlphaNum = (c) -> _.contains alphaNums, c

describe "char functions", ->
  describe "isLower", ->
    it "returns true for all lower case chars, else false", ->
      _.all ascii, (v) -> expect(isLower v).equal(c.isLower v)


  describe "isUpper", ->
    it "returns true for all upper case chars, else false", ->
      _.all ascii, (v) -> expect(isUpper v).equal(c.isUpper v)

  describe "isLetter", ->
    it "returns true for all letters, false otherwise", ->
      _.all ascii, (v) -> expect(isLetter v).equal(c.isLetter v)


  describe "isDigit", ->
    it "returns true for all digits, false otherwise", ->
      _.all ascii, (v) -> expect(isDigit v).equal(c.isDigit v)

  describe "isAlphaNum", ->
    it "returns true for any letter or digit", ->
      _.all ascii, (v) -> expect(isAlphaNum v).equal(c.isAlphaNum v)

exports.charRange = charRange
exports.ascii = ascii
