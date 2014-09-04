
(function() {
"use strict";

var Tuple = function Tuple() {
  var i = this.length = arguments.length;
  while(i--)
    this[i] = arguments[i];
};

Tuple.prototype.unpack = function unpack(f) {
  return f.apply(this, this);
};

Tuple.prototype.first = function first() {
  return this.unpack(function(f,s) { return f; });
};

Tuple.prototype.second = function second() {
  return this.unpack(function(_,s) { return s; } );
};

Tuple.prototype.toArray = function toArray() {
  return Array.prototype.slice.call(this);
};

Tuple.prototype.toString = function toString() {
  return ["(", this.toArray().join(","), ")"].join("");
};

module.exports = Tuple;
})();
