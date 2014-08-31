Maybe = require './maybe.js'
Tuple = require './tuple.coffee'

class Parser
  constructor: (@parseFunction) ->

  parse: (str) ->
    return @parseFunction(str)

failure = new Parser (s) -> Maybe.nothing()
success = (value) -> new Parser (s) -> Maybe.just(new Tuple(value, s))

exports.failure = failure
exports.success = success
