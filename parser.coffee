Maybe = require './maybe.js'
Tuple = require './tuple.coffee'
char = require './char.coffee'

class Parser
  constructor: (parseFunction) ->
    @parseFunction = parseFunction

  parse: (str) -> @parseFunction(str)

  # Note the use of super special fat arrow, thin arrow gives infitine loop
  bind: (f) -> new Parser (str) =>
    @parseFunction(str).bind (parseResult) ->
      parseResult.unpack (parsed, strout) ->
        f(parsed).parse strout

  or: (parser) -> new Parser (str) =>
    result = @parseFunction str
    result.case(
      -> parser.parse str,
      -> result)

  lift: (f) -> @bind (v) -> Parser.success f(v)

  @failure = new Parser((str) -> Maybe.nothing())
  @success = (value) -> new Parser((str) -> Maybe.just(new Tuple(value, str)))
  @item = new Parser((str) ->
    switch str
      when "" then return Maybe.nothing()
      else return Maybe.just(new Tuple(str[0], str.slice 1)))

  @sat = (predicate) ->
    return Parser.item.bind (c) ->
      if predicate(c) then Parser.success(c) else Parser.failure



  @lift2 = (f) -> (parser1) -> (parser2) ->
    parser1.bind (v1) -> parser2.bind (v2) -> Parser.success f(v1)(v2)

  @string = (expected) ->
    if expected.length == 0 then Parser.success ""
    else (Parser.sat (v) -> v is expected[0]).bind (c) ->
      (Parser.string expected.slice 1).bind (cs) ->
        Parser.success c + cs

  @lower = Parser.sat char.isLower
  @upper = Parser.sat char.isUpper
  @letter = Parser.sat char.isLetter
  @digit = Parser.sat char.isDigit
  @alphaNum = Parser.sat char.isAlphaNum

  @many = (parser) ->
    Parser.many1(parser).or Parser.success []

  @many1 = (parser) ->
    parser.bind (t) ->
      Parser.many(parser).bind (ts) ->
        Parser.success [t].concat ts

  @manys = (parser) ->
    Parser.manys1(parser).or Parser.success ""

  @manys1 = (parser) ->
    parser.bind (c) ->
      Parser.manys(parser).bind (cs) ->
        Parser.success c + cs

  @space = Parser.many(Parser.sat char.isSpace).bind (vs) -> Parser.success null

  @ident = Parser.letter.bind (c) ->
    Parser.manys(Parser.alphaNum).bind (cs) ->
      Parser.success c + cs

  @nat = Parser.digit.bind (d) ->
    Parser.manys(Parser.digit).bind (ds) ->
      Parser.success d+ds

  @token = (parser) ->
    Parser.space.bind (s1) ->
      parser.bind (v) ->
        Parser.space.bind (s2) ->
          Parser.success v

  @identifier = Parser.token Parser.ident
  @natural = Parser.token Parser.nat
  @symbol = (str) -> Parser.token (Parser.string str)

module.exports = Parser
