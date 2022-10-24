# nimstdvector.nim

{.push header: "<vector>".}
type
  Vector*[T] {.importcpp: "std::vector".} = object
  VectorIterator*[T] {.importcpp: "std::vector<'0>::iterator".} = object

proc newVector*[T](): Vector[T]
  {.importcpp: "std::vector<'*0>(@)", constructor.}

proc size*[T](v: Vector[T]): csize_t {.importcpp: "size".}
proc pushBack*[T](v: var Vector[T]; x: T) {.importcpp: "push_back".}
proc popBack*[T](v: var Vector[T]) {.importcpp: "pop_back".}
proc clear*[T](v: var Vector[T]) {.importcpp: "clear".}
proc begin*[T](v: Vector[T]): VectorIterator[T] {.importcpp: "begin".}
proc `end`*[T](v: Vector[T]): VectorIterator[T] {.importcpp: "end".}
proc `[]`*[T](it: VectorIterator[T]): T {.importcpp: "(*#)".}
proc inc*[T](it: var VectorIterator[T]) {.importcpp: "(++#)".}
proc next*[T](it: VectorIterator[T]; n: cint=1): VectorIterator[T]
  {.importcpp: "next(@)".}
proc `<`*[T](a, b: VectorIterator[T]): bool {.importcpp: "operator<(@)".}
proc `<=`*[T](a, b: VectorIterator[T]): bool {.importcpp: "operator<=(@)".}
proc at*[T](v: Vector[T], idx: cint): ref T {.importcpp: "&#.at(@)".}
proc at*[T](v: ref Vector[T], idx: cint): ref T {.importcpp: "&#->at(@)".}
{.pop.}
