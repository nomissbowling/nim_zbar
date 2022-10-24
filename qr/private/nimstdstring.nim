# nimstdstring.nim

{.push header: "<string>".}
type
  StdString* {.importcpp: "std::string".} = object

proc newStdString*(): StdString
  {.importcpp: "std::string(@)", constructor.}

proc newStdString*(s: cstring): StdString
  {.importcpp: "std::string(@)", constructor.}

proc cStr*(s: StdString): cstring {.importcpp: "#.c_str()".} # use as $s.cStr
proc at*(s: StdString, idx: cint): char {.importcpp: "#.at(@)".}
proc at*(s: ref StdString, idx: cint): char {.importcpp: "#->at(@)".}
{.pop.}
