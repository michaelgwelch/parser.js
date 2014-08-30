

(function() {
"use strict";

var NoValueException = function NoValueException(functionName) {
  this.message = [functionName, ": Called on a Nothing Maybe"].join("");
};

var Maybe = function Maybe(value) {

  this.value = value;
  this.hasValue = !(value === null || value === undefined);

};

Maybe.prototype.isNothing = function isNothing() {
  return !this.hasValue;
};

Maybe.prototype.isJust = function isJust() {
  return this.hasValue;
};

Maybe.prototype.fromJust = function fromJust() {
  if (this.hasValue) return this.value;
  throw new NoValueException("fromJust");
};

Maybe.prototype.fromMaybe = function fromMaybe(defaultValue) {
  return this.hasValue ? this.value : defaultValue;
};

Maybe.prototype.maybe = function maybe(defaultValue, f) {
  return this.hasValue ? f(this.value) : defaultValue;
};

module.exports = Maybe;

})();
