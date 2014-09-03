
(function() {
  "use strict";
  var p = require("./parser.js");

  //Parser String
  var regchar = p.sat(function(c) {
    return c !== "|" && c !== "*" && c !== "(" && c !== ")";
  });

  // Parser (Parser String)
  var charexpr = regchar.bind(function(c) { return p.success(p.string(c)); });

  // Parser (Parser String)
  var parenexpr = p.string("(").bind(function(_){
    return getExpr().bind(function(expr) {
      return p.string(")").bind(function(_) {
        return p.success(expr);
      });
    });
  });

  // Parser (Parser String)
  var basicexpr = parenexpr.or(charexpr);

  // [String] -> String
  var joinStrings = function(arrayOfStrings) { return arrayOfStrings.join(""); };

  // Parser (Parser String)
  var repeatexpr = (function() {
    var option1 = basicexpr.bind(function(be) {
      return p.string("*").bind(function(_) {
        return p.success(p.lift(p.many(be), joinStrings));
      });
    });
    var option2 = basicexpr;
    return option1.or(option2);
  })();



  // String -> String -> String
  var concatStrings = function(s1, s2) { return s1 + s2; };

  // Parser (Parser String)
  var concatexpr = (function() {
    var option1 = repeatexpr.bind(function(re) {
      return concatexpr.bind(function(ce) {
        return p.success(p.lift2(concatStrings,re,ce));
      });
    });
    var option2 = repeatexpr;
    return option1.or(option2);
  })();

  // Parser (Parser String)
  var orexpr = (function() {
    var option1 = concatexpr.bind(function(ce) {
      return p.string("|").bind(function(_) {
        return orexpr.bind(function(oe) {
          return p.success(ce.or(oe));
        });
      });
    });
    var option2 = concatexpr;
    return option1.or(option2);
  })();

  // () -> Parser (Parser String)
  var getExpr = function() { return orexpr; };

  // Pattern is of type String
  // Pattern -> Parser String
  var compile = function(str) {
    return (str.length === 0) ? p.string("") :
      orexpr.parse(str).maybe(p.failure, function(tuple) {
        return tuple.unpack(function(parsed, remaining) {
          return (remaining.length === 0) ? parsed : p.failure;
        });
      });
  };

  // Pattern is of type String
  // (Pattern, String) -> Bool
  var accepts = function(pattern,input) {
    var parser = compile(pattern);
    return parser.parse(input).maybe(false,function(tuple) {
      return tuple.unpack(function(parsed, remaining) {
        return (remaining.length === 0);
      });
    });
  };

exports.charexpr = charexpr;
exports.parenexpr = parenexpr;
exports.basicexpr = basicexpr;
exports.repeatexpr = repeatexpr;
exports.concatexpr = concatexpr;
exports.orexpr = orexpr;
exports.compile = compile;
exports.accepts = accepts;
})();
