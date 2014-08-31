Maybe = require './maybe.js'
Tuple = require './tuple.coffee'

class Parser
  constructor: (parseFunction) ->
    @parseFunction = parseFunction

  parse: (str) -> @parseFunction(str)

  # Note the use of super special fat arrow, thin arrow gives infitine loop
  bind: (f) -> new Parser (str) =>
    @parseFunction(str).bind (parseResult) ->
      parseResult.unpack (parsed, strout) ->
        f(parsed).parse strout

failure = new Parser((str) -> Maybe.nothing())
success = (value) -> new Parser((str) -> Maybe.just(new Tuple(value, str)))
item = new Parser((str) ->
  switch str
    when "" then return Maybe.nothing()
    else return Maybe.just(new Tuple(str[0], str.slice 1)))

sat = (predicate) ->
  return item.bind (c) -> if predicate(c) then success(c) else failure

lift = (f) -> (parser) -> parser.bind (v) -> success f(v)
lift2 = (f) -> (parser1) -> (parser2) ->
  parser1.bind (v1) -> parser2.bind (v2) -> success f(v1)(v2)

string = (expected) ->
  if expected.length == 0 then success ""
  else (sat (v) -> v is expected[0]).bind (c) ->
    (string expected.slice 1).bind (cs) ->
      success c + cs


exports.failure = failure
exports.success = success
exports.item = item
exports.sat = sat
exports.lift = lift
exports.lift2 = lift2
exports.string = string
