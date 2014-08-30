

(function() {
"use strict";
var Maybe = function Maybe(value) {

  this.value = value;

};

Maybe.prototype.isNothing = function isNothing() {
  return this.value === null || this.value === undefined;
};

Maybe.prototype.isJust = function isJust() {
  return !this.isNothing();
};

module.exports = Maybe;

})();
