require('should')
assert = require('assert')
Maybe = require('../maybe.coffee')

describe "Maybe", ->

  describe "#isNothing", ->
    it "should return true if Maybe is created with no value.", ->
      new Maybe().isNothing().should.be.true


    it "should return false if Maybe is created with a value.", ->
      new Maybe(5).isNothing().should.be.false


    it "should return true if Maybe is created with a null value.", ->
      new Maybe(null).isNothing().should.be.true


    it "should return false if Maybe is created with false.", ->
      new Maybe(false).isNothing().should.be.false


    it "should return false if Maybe is created with 0 value.", ->
      new Maybe(0).isNothing().should.be.false


    it "should return false if Maybe is created with '' value", ->
      new Maybe('').isNothing().should.be.false


    it "should return false if Maybe is created with NaN value", ->
      new Maybe(NaN).isNothing().should.be.false


  describe "#isJust", ->
    # TODO: figure out how to do "parameterized" testing so I can just
    # run each test with a table of data.
    it "should return false if Maybe is created with no value.", ->
      new Maybe().isJust().should.be.false


    it "should return true if Maybe is created with a value.", ->
      new Maybe(5).isJust().should.be.true



  describe "#fromJust", ->
    it "returns the value extracted from a Maybe if it has one," +
    " else it throws an error", ->
      new Maybe(5).fromJust().should.equal(5)


    it "throws an exception on a Nothing instance of Maybe", ->
      (-> new Maybe().fromJust()).should.throw()



  describe "#fromMaybe", ->
    it "Returns the specified default value when call on a Nothing instance.",
    ->
      new Maybe().fromMaybe("hello").should.equal("hello")


    it "Returns the extracted value when there is one.", ->
      new Maybe("the").fromMaybe("hello").should.equal("the")



  describe "#maybe", ->
    it "given Just 5 and increment function returns 6", ->
      incr = (v) -> v + 1
      new Maybe(5).maybe(0, incr).should.equal(6)


    it "give Nothing returns specified default value of -10", ->
      incr = (v) -> v + 1
      new Maybe().maybe(-10, incr).should.equal(-10)

  describe "#map", ->
    describe "Has type: Maybe a -> (a -> b) -> Maybe b", ->
      it "Given a Nothing instance returns Nothing", ->
        new Maybe().map(parseInt).equals(new Maybe()).should.be.true


      it "Given a Just '5' and parseInt returns Just 5", ->
        new Maybe('5').map(parseInt).equals(new Maybe(5)).should.be.true

  describe ".nothing", ->
    it "Returns an object that is equal to new Maybe()", ->
      Maybe.nothing().equals(new Maybe()).should.be.true


    it "is immutable", ->
      n = Maybe.nothing()
      n.value = 23
      assert.equal(n.value, undefined)




  describe ".just", ->
    it "just(x) returns an object equal to new Maybe(x)", ->
      Maybe.just(3).equals(new Maybe(3)).should.be.true



  describe "#bind", ->
    it "returns nothing if called on nothing", ->
      Maybe.nothing().bind(undefined).equals(Maybe.nothing()).should.be.true


    it "applies specified function and returns result of applying it" + "
     to the value of a just", ->
      maybeParseInt = (str) -> return Maybe.just(parseInt(str))
      Maybe.just("3").bind(maybeParseInt).equals(Maybe.just(3))



  describe "#toString", ->
    it "returns 'Nothing' when called on a nothing instance", ->
      Maybe.nothing().toString().should.be.equal("Nothing")


    it "returns 'Just 5' when called on Maybe.just(5)", ->
      Maybe.just(5).toString().should.be.equal("Just 5")



  describe "#case", ->
    it "calls first function argument when nothing", ->
      Maybe.nothing().case(
        -> ,
        (value) -> assert.fail("Expected nothing case to be called.")
      )


    it "calls second function argument when just", ->
      Maybe.just(5).case(
        ->  assert.fail("Expect just case to be called."),
        (value) -> value.should.equal(5)
      )
