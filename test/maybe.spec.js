require('should');
var assert = require('assert');
var Maybe = require('../maybe');

/* jshint -W030 */ // turn off the jshint 'Expected an assignment or function call and instead saw an expression.'
describe("Maybe", function() {

  describe("#isNothing", function() {
    it("should return true if Maybe is created with no value.", function() {
      new Maybe().isNothing().should.be.true;
    });

    it("should return false if Maybe is created with a value.", function() {
      new Maybe(5).isNothing().should.be.false;
    });

    it("should return true if Maybe is created with a null value.", function() {
      new Maybe(null).isNothing().should.be.true;
    });

    it("should return false if Maybe is created with false.", function() {
      new Maybe(false).isNothing().should.be.false;
    });

    it("should return false if Maybe is created with 0 value.", function() {
      new Maybe(0).isNothing().should.be.false;
    });

    it("should return false if Maybe is created with '' value", function() {
      new Maybe('').isNothing().should.be.false;
    });

    it("should return false if Maybe is created with NaN value", function() {
      new Maybe(NaN).isNothing().should.be.false;
    });

  });

  describe("#isJust", function() {
    // TODO: figure out how to do "parameterized" testing so I can just
    // run each test with a table of data.
    it("should return false if Maybe is created with no value.", function() {
      new Maybe().isJust().should.be.false;
    });

    it("should return true if Maybe is created with a value.", function() {
      new Maybe(5).isJust().should.be.true;
    });
  });

  describe("#fromJust", function() {
    it("returns the value extracted from a Maybe if it has one, else it throws an error",
    function() {
      new Maybe(5).fromJust().should.equal(5);
    });

    it("throws an exception on a Nothing instance of Maybe", function() {
      (function() {new Maybe().fromJust();}).should.throw();
    });
  });

  describe("#fromMaybe", function() {
    it("Returns the specified default value when call on a Nothing instance.",
    function() {
      new Maybe().fromMaybe("hello").should.equal("hello");
    });

    it("Returns the extracted value when there is one.", function() {
      new Maybe("the").fromMaybe("hello").should.equal("the");
    });
  });

  describe("#maybe", function() {
    it("given Just 5 and increment function returns 6", function() {
      function incr(v) { return v + 1; }
      new Maybe(5).maybe(0, incr).should.equal(6);
    });

    it("give Nothing and an increment function just returns specified default value of -10",
    function() {
      function incr(v) { return v + 1; }
      new Maybe().maybe(-10, incr).should.equal(-10);
    });

  });



  describe("#map", function() {
    describe("Has type: Maybe a -> (a -> b) -> Maybe b", function() {
      it("Given a Nothing instance returns Nothing", function() {
        new Maybe().map(parseInt).equals(new Maybe()).should.be.true;
      });

      it("Given a Just '5' and parseInt returns Just 5", function() {
        new Maybe('5').map(parseInt).equals(new Maybe(5)).should.be.true;
      });
    });

  });

  describe("nothing class method", function() {
    it("Returns an object that is equal to new Maybe()", function() {
      Maybe.nothing().equals(new Maybe()).should.be.true;
    });

    it("is immutable", function() {
      var n = Maybe.nothing();
      n.value = 23;
      assert.equal(n.value, undefined);
    });

  });

  describe("just class method", function() {
    it("just(x) returns an object equal to new Maybe(x)", function() {
      Maybe.just(3).equals(new Maybe(3)).should.be.true;
    });
  });



});
