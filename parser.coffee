Maybe = require './maybe.js'

class Parser
  constructor: (@parseFunction) ->

  parse: (str) ->
    return Maybe.nothing()

failure = new Parser (s) -> Maybe.nothing()

exports.failure = failure
