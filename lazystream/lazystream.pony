use "ponytest"

class Stream[A]
  """
  Lazy stream implementation based on ocaml's stream library:
  https://caml.inria.fr/pub/docs/manual-ocaml/libref/Stream.html
  """
  _head: A
  _fn: ({(A): A} val)

  new from(fn': ({(A): A} val), head': A) =>
    _head = head'
    _fn = fn'

  fun next(): Stream[A] =>
    _fn(_head)


actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(_TestUnit)


class iso _TestUnit is UnitTest
  fun name(): String => "Unit"

  fun apply(h: TestHelper) =>
    let xs: Stream[USize] = StreamCons[USize].cons(2, StreamCons[USize].cons(1, StreamNil))
