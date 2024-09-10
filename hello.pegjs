start
  = additive

additive
  = left:multiplicative "+" right:additive { return {left: left, right: right, op: 'addition'}; }
  / multiplicative

multiplicative
  = left:primary "*" right:multiplicative { return {left: left, right: right, op: 'multiplication'}; }
  / primary

primary
  = integer
  / "(" additive:additive ")" { return additive; }

integer "simple number"
  = digits:[0-9]+ { return parseInt(digits.join(""), 10); }