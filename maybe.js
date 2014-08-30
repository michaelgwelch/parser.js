

(function() {
"use strict";

var NoValueException = function NoValueException(functionName) {
  this.message = [functionName, ": Called on a Nothing Maybe"].join("");
}

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
}

module.exports = Maybe;

})();
