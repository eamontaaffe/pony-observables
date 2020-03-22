use "ponytest"
use "promises"

actor Stream[A: Any #share]
  """
  Asynchronous functional stream implementation.

  Stream3 -> Stream2 -> Stream1 -> Stream0
  Stream3 = (Item1, (Item2, (Item3, Nil)))

  TODO:
  - Does this need to be an actor? Could it be a class?
  - How would read file stream look?
  - Write some helper functions to get some elements from the list in one
    shot. Like take(x: USize): Promise[Array[A]].
  - Memoize the value of _fn(_head) so that it doesn't need to be recomputed.
  - How do you express the end of a stream? Stream[None] maybe?
  """
  let _head: A
  let _fn: {(A): A} val

  new create(fn': ({(A): A} val), head': A) =>
    _head = head'
    _fn = fn'

  be head(p: Promise[A]) =>
    p(_head)

  be tail(p: Promise[Stream[A]]) =>
    p(Stream[A].create(_fn, _fn(_head)))


actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(_TestNats)
    test(_TestFibs)


class iso _TestFibs is UnitTest
  fun name(): String => "Fibs"

  fun apply(h: TestHelper) =>
    h.long_test(1_000)

    let fibs = Stream[(USize, USize)].create(
      {(x) => (x._1, x._1 + x._2)},
      (0, 1)
    )

    let p_head = Promise[(USize, USize)]
    p_head.next[None]({(x) => h.assert_eq[USize](0, x._1)
                              h.assert_eq[USize](1, x._2)})
          .next[None]({(_) => h.complete(true)})

    fibs.head(p_head)

class iso _TestNats is UnitTest
  fun name(): String => "Nats"

  fun apply(h: TestHelper) =>
    h.long_test(1_000)

    let nats = Stream[USize].create({(x) => x + 1}, 1)

    let p_head = Promise[USize]
    p_head.next[None]({(x) => h.assert_eq[USize](x, 1)})
    nats.head(p_head)

    let p_tail = Promise[Stream[USize]]
    let p_head' = Promise[USize]

    p_head'.next[None]({(x) => h.assert_eq[USize](x, 2)})
           .next[None]({(_) => h.complete(true)})

    p_tail.next[None]({(nats') => nats'.head(p_head')})

    nats.tail(p_tail)
