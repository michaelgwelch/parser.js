(function() {
  "use strict";
  var Maybe = require('./maybe.js');
  var Tuple = require('./tuple.js');
  var char = require('./char.js');

  var Parser = function Parser(parseFunction) {
    this.parseFunction = parseFunction;
  };

  Parser.prototype.parse = function (str) {
    return this.parseFunction(str);
  };


  Parser.prototype.bind = function (f) {
    return new Parser(
      (function(str) {
        return this.parseFunction(str).bind(function(parseResult) {
          return parseResult.unpack(function(parsed, remaining) {
            return f(parsed).parse(remaining);
          });
        });
      }).bind(this)
    );
  };

  Parser.prototype.map = function(f) {
    return this.bind(function(v) {
      return Parser.success(f(v));
    });
  };

  Parser.prototype.or = function(parser) {
    return new Parser((function(str) {
      return this.parseFunction(str).case(
        function(_) { return parser.parse(str); }, // nothing case
        function(_,original) { return original; }  // just case
      );
    }).bind(this));
  };

  Parser.prototype.concat = function(parser) {
    return this.bind(function(array1) {
      return parser.bind(function(array2) {
        return Parser.success(array1.concat(array2));
      });
    });
  };

  Parser.prototype.concats = function(parser) {
    return this.bind(function(str1) {
      return parser.bind(function(str2) {
        return Parser.success(str1 + str2);
      });
    });
  };

  Parser.lift = function(parser, f) {
    // Class method version of #map, so just delegate to map
    return parser.map(f);
  };

  Parser.failure = new Parser(
    function(str) {
      return Maybe.nothing();
    }
  );

  Parser.success = function(value) {
    return new Parser(function(str) {
      return Maybe.just(new Tuple(value,str));
    });
  };

  Parser.item = new Parser(function(str) {
    return (str === "") ? Maybe.nothing() :
      Maybe.just(new Tuple(str[0], str.slice(1)));
  });


  Parser.sat = function(predicate) {
    return Parser.item.bind(function(c) {
      return predicate(c) ? Parser.success(c) : Parser.failure;
    });
  };

  Parser.lift2 = function(f, parser1, parser2) {
    return parser1.bind(function(v1) {
      return parser2.bind(function(v2) {
        return Parser.success(f(v1,v2));
      });
    });
  };

  Parser.string = function(expected) {
    return (expected === "") ? Parser.success("") :
      Parser.sat(function(v) {
        return v === expected[0];
      }).bind(function(c) {
        return Parser.string(expected.slice(1)).bind(function(cs) {
        return Parser.success(c + cs);
      });
    });
  };

  Parser.lower = Parser.sat(char.isLower);
  Parser.upper = Parser.sat(char.isUpper);
  Parser.letter = Parser.sat(char.isLetter);
  Parser.digit = Parser.sat(char.isDigit);
  Parser.alphaNum = Parser.sat(char.isAlphaNum);

  Parser.many = function(p) {
    return Parser.many1(p).or(Parser.success([]));
  };

  Parser.many1 = function(p) {
    return p.bind(function (t) {
      return Parser.many(p).bind(function (ts) {
        return Parser.success([t].concat(ts));
      });
    });
  };

  Parser.manys = function(parser) {
    return Parser.manys1(parser).or(Parser.success(""));
  };

  Parser.manys1 = function(parser) {
    return parser.bind(function(c) {
      return Parser.manys(parser).bind(function(cs) {
        return Parser.success(c+cs);
      });
    });
  };

  Parser.space = Parser.many(Parser.sat(char.isSpace)).bind(function (vs) {
    return Parser.success(null);
  });

  Parser.ident = Parser.letter.bind(function(c) {
    return Parser.manys(Parser.alphaNum).bind(function(cs) {
      return Parser.success(c+cs);
    });
  });

  Parser.nat = Parser.digit.bind(function(d) {
    return Parser.manys(Parser.digit).bind(function(ds) {
      return Parser.success(d+ds);
    });
  });

  Parser.token = function(parser) {
    return Parser.space.bind(function(_) {
      return parser.bind(function(v) {
        return Parser.space.bind(function(_) {
          return Parser.success(v);
        });
      });
    });
  };

  Parser.identifier = Parser.token(Parser.ident);
  Parser.natural = Parser.token(Parser.nat);
  Parser.symbol = function(str) {
    return Parser.token(Parser.string(str));
  };

module.exports = Parser;
})();
