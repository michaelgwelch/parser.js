
# just for fun
predicateOr = (predicate1) -> (predicate2) -> (value) ->
  predicate1(value) || predicate2(value)

isLower = (c) -> c >= "a" && c <= "z"
isUpper = (c) -> c >= "A" && c <= "Z"
isLetter = predicateOr(isLower)(isUpper)
isDigit = (c) -> c >= "0" && c <= "9"
isAlphaNum = predicateOr(isLetter)(isDigit)

exports.isLower = isLower
exports.isUpper = isUpper
exports.isLetter = isLetter
exports.isDigit = isDigit
exports.isAlphaNum = isAlphaNum
