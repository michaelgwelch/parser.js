
_ = require('lodash')

class NoValueException
  constructor: (@functionName) ->
    this.message = [functionName, ": Called on nothing"].join("")

constfunc = (x) -> (_) -> x
id = (x) -> x


class Maybe
  constructor: (@value) ->
    @hasValue = !(value == null || value == undefined)

  @nothingObject = Object.freeze(new Maybe());

  # Most functions written in terms of maybe and case, just because.
  # Probably (much?) less efficient, but also less duplication.

  isNothing: -> @maybe true, constfunc(false)

  isJust: -> @maybe false, constfunc(true)

  fromJust: -> @case(
    -> throw new NoValueException("fromJust"),
    constfunc(@value))

  fromMaybe: (defaultValue) -> @maybe defaultValue, id

  maybe: (defaultValue, f) -> @case constfunc(defaultValue), f

  equals: (other) -> @maybe !other.hasValue, _.isEqual.bind(_, @value)

  map: (f) -> @maybe Maybe.nothingObject, (v) -> new Maybe(f(v))

  bind: (f) -> @maybe Maybe.nothingObject, (v) -> f(v)

  toString: -> @maybe "Nothing", (v) -> ["Just",v].join " "

  case: (nothingCase, justCase) ->
    if @hasValue then justCase(@value) else nothingCase()

  @nothing = -> Maybe.nothingObject

  @just = (value) -> new Maybe(value)

module.exports = Maybe
