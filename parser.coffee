Maybe = require './maybe.js'
Tuple = require './tuple.coffee'

class Parser
  constructor: (@parseFunction) ->

  parse: (str) ->
    return @parseFunction(str)

failure = new Parser (str) -> Maybe.nothing()
success = (value) -> new Parser (str) -> Maybe.just(new Tuple(value, str))
item = new Parser (str) ->
  switch str
    when "" then return Maybe.nothing()
    else return Maybe.just(new Tuple(str[0], str.slice 1))

exports.failure = failure
exports.success = success
exports.item = item
