

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

// Most functions written in terms of #maybe, just because.

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
  if (this.hasValue) return this.value;
  throw new NoValueException("fromJust");
};

Maybe.prototype.fromMaybe = function fromMaybe(defaultValue) {
  return this.maybe(defaultValue, id);
};

Maybe.prototype.maybe = function maybe(defaultValue, f) {
  return this.case(constfunc(defaultValue), f);
};

Maybe.prototype.equals = function equals(other) {
  if (this.hasValue) return _.isEqual(this, other);
  return !other.hasValue;
};

Maybe.prototype.map = function map(f /* f: a -> b */) {
  return this.hasValue ? new Maybe(f(this.value)) : nothingObject;
};

Maybe.prototype.bind = function bind(f /* f: a -> Maybe b */) {
  return this.hasValue ? f(this.value) : nothingObject;
};

Maybe.prototype.toString = function() {
  return this.maybe("Nothing", function(v) {
    return ["Just",v].join(" ");
  });
};

Maybe.prototype.ifJust = function ifJust(f) {
  return this.maybe(null, f);
};

Maybe.prototype.case = function(nothingCase, justCase) {
  if (this.hasValue) return justCase(this.value);
  return nothingCase();
};

var nothingObject = Object.freeze(new Maybe());

Maybe.nothing = function nothing() {
  return nothingObject;
};

Maybe.just = function just(value) {
  return new Maybe(value);
};

module.exports = Maybe;

})();
