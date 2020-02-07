import npeg
# Grammar rules:

let parser = peg "CompoundPropStart":
  Variable                <- +Alpha
  StmtTemplate(conn)      <- Variable * *Space * conn * *Space * Statement
  AndStatement            <- StmtTemplate("&&")
  OrStatement             <- StmtTemplate("||")
  ImpliesStatement        <- StmtTemplate("->")
  Statement               <- ImpliesStatement | AndStatement | OrStatement | Variable
  BracketedStmt           <- '(' * *Space * Statement * *Space * ')'
  Prop                    <- BracketedStmt | Statement
  PropTemplate(conn)      <- Prop * *Space * conn * *Space * CompoundProps
  AndProps                <- PropTemplate("&&")
  OrProps                 <- PropTemplate("||")
  ImpliesProps            <- PropTemplate("->")
  CompoundProps           <- ImpliesProps | AndProps | OrProps | Prop
  CompoundPropStart       <- CompoundProps * !1



when isMainModule:
  # Tests
  # Valid strings
  doAssert parser.match("p").ok
  doAssert parser.match("p && q").ok
  doAssert parser.match("p || q").ok
  doAssert parser.match("p && q && q").ok
  doAssert parser.match("(p && q && q)").ok
  doAssert parser.match("p -> q").ok
  doAssert parser.match("(p -> q )").ok
  doAssert parser.match("(p -> q) && (p -> r)").ok
  doAssert parser.match("(p -> q) && (p -> r) && p").ok
  doAssert parser.match("(p && q || r)").ok
  doAssert parser.match("p -> q && r").ok
  # Invalid strings
  doAssert not parser.match("(p && q").ok
  doAssert not parser.match("p && q)").ok
  doAssert not parser.match("(p && q) ->").ok
  doAssert not parser.match("(->A && q)").ok

