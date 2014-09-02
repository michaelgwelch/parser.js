p = require "./parser.coffee"

#Parser String
regchar = p.sat (c) -> c != "|" && c != "*" && c != "(" && c != ")"

# Parser (Parser String)
charexpr = regchar.bind (c) -> p.success (p.string c)

# Parser (Parser String)
parenexpr = p.string("(").bind (_) ->
  getExpr().bind (expr) ->
    p.string(")").bind (_) ->
      p.success expr

# Parser (Parser String)
basicexpr = parenexpr.or charexpr

# [String] -> String
joinStrings = (arrayOfStrings) -> arrayOfStrings.join ""

# Parser (Parser String)
repeatexpr = ( ->
  option1 = basicexpr.bind (be) ->
    p.string("*").bind (_) ->
      p.success(p.many(be).lift joinStrings)
  option2 = basicexpr
  option1.or option2)()

# String -> String -> String
concatStrings = (s1) -> (s2) -> s1 + s2

# Parser (Parser String)
concatexpr = ( ->
  option1 = repeatexpr.bind (re) ->
    concatexpr.bind (ce) ->
      p.success p.lift2(concatStrings)(re)(ce)
  option2 = repeatexpr
  option1.or option2)()

# Parser (Parser String)
orexpr = ( ->
  option1 = concatexpr.bind (ce) ->
    p.string("|").bind (_) ->
      orexpr.bind (oe) ->
        p.success ce.or(oe)
  option2 = concatexpr
  option1.or option2)()

# () -> Parser (Parser String)
getExpr = -> orexpr

# Pattern is of type String
# Pattern -> Parser String
compile = (str) ->
  if str.length == 0
    p.string ""
  else
    orexpr.parse(str).maybe(p.failure,
    (tuple) -> tuple.unpack (parsed, remaining) ->
      if remaining.length == 0 then parsed else failure)

# Pattern is of type String
# (Pattern, String) -> Bool
accepts = (pattern, input) ->
  parser = compile pattern
  parser.parse(input).maybe(false,
  (tuple) -> tuple.unpack (parsed, remaining) ->
    if remaining.length == 0 then true else false)

exports.charexpr = charexpr
exports.parenexpr = parenexpr
exports.basicexpr = basicexpr
exports.repeatexpr = repeatexpr
exports.concatexpr = concatexpr
exports.orexpr = orexpr
exports.compile = compile
exports.accepts = accepts
