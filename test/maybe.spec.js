require('should');

var Maybe = require('../maybe');

/* jshint -W030 */ // turn off the jshint 'Expected an assignment or function call and instead saw an expression.'
describe("Maybe", function() {

  describe("#isNothing", function() {
    it("should return true if Maybe is created with no value.", function() {
      new Maybe().isNothing().should.be.true;
    });

    it("should return false if Maybe is created with a value.", function() {
      new Maybe(5).isNothing().should.be.true;
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


});
