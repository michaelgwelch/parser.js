

(function() {
"use strict";

var _ = require('lodash');

var NoValueException = function NoValueException(functionName) {
  this.message = [functionName, ": Called on a Nothing Maybe"].join("");
};

var Maybe = function Maybe(value) {

  this.hasValue = !(value === null || value === undefined);
  this.value = value;
};

var nothingObject = Object.freeze(new Maybe());


// Most functions written in terms of maybe and case, just because.
// Probably (much?) less efficient, but also less duplication.

function constfunc(x) {
  return function(_) {
    return x;
  };
}

function id(x) {
  return x;
}

Maybe.prototype.isNothing = function isNothing() {
  return this.maybe(true, constfunc(false));
};

Maybe.prototype.isJust = function isJust() {
  return this.maybe(false, constfunc(true));
};

Maybe.prototype.fromJust = function fromJust() {
  return this.case(
    function() { throw new NoValueException("fromJust"); },
    constfunc(this.value)
  );
};

Maybe.prototype.fromMaybe = function fromMaybe(defaultValue) {
  return this.maybe(defaultValue, id);
};

Maybe.prototype.maybe = function maybe(defaultValue, f) {
  return this.case(constfunc(defaultValue), f);
};

Maybe.prototype.equals = function equals(other) {
  return this.maybe(!other.hasValue,
    function(v) { return _.isEqual(v,other.value); });
};

Maybe.prototype.map = function map(f /* f: a -> b */) {
  return this.maybe(nothingObject,
    function(v) { return new Maybe(f(v)); });
};

Maybe.prototype.bind = function bind(f /* f: a -> Maybe b */) {
  return this.maybe(nothingObject,
    function(v) { return f(v); });
};

Maybe.prototype.toString = function() {
  return this.maybe("Nothing", function(v) {
    return ["Just",v].join(" ");
  });
};

Maybe.prototype.case = function(nothingCase, justCase) {
  return this.hasValue ? justCase(this.value, this) : nothingCase();
};

Maybe.nothing = function nothing() {
  return nothingObject;
};

Maybe.just = function just(value) {
  return new Maybe(value);
};

module.exports = Maybe;

})();
