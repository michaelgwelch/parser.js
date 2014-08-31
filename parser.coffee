Maybe = require './maybe.js'
Tuple = require './tuple.coffee'

class Parser
  constructor: (parseFunction) ->
    @parseFunction = parseFunction

  parse: (str) -> @parseFunction(str)

  bind: (f) -> new Parser (str) => # Note the use of super special fat arrow, thin arrow results in an infitine loop
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

exports.failure = failure
exports.success = success
exports.item = item
exports.sat = sat
