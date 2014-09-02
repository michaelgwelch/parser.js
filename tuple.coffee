class Tuple
  constructor: () ->
    i = this.length = arguments.length

    while(i--)
      this[i] = arguments[i]

  @pack2: (x,y) -> return new Tuple(x,y)

  unpack: (f) ->
    f.apply this, this

  first: -> @unpack (f) -> f

  second: -> @unpack (_,s) -> s

  toArray: ->
    return Array.prototype.slice.call(this)

  toString: ->
    return ["(", this.toArray().join(","), ")"].join ""

module.exports = Tuple
