use "ponytest"
use "promises"

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
