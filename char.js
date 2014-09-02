
(function() {
  "use strict";

  var isLower = function(c) { return c >= "a" && c <= "z"; };
  var isUpper = function(c) { return c >= "A" && c <= "Z"; };
  var isLetter = function(c) { return isLower(c) || isUpper(c); };
  var isDigit = function(c) { return c >= "0" && c <= "9"; };
  var isAlphaNum = function(c) { return isLetter(c) || isDigit(c); };
  var isSpace = function(c) { return c === " " || c === "\n" || c === "\t"; };

  exports.isLower = isLower;
  exports.isUpper = isUpper;
  exports.isLetter = isLetter;
  exports.isDigit = isDigit;
  exports.isAlphaNum = isAlphaNum;
  exports.isSpace = isSpace;
})();
