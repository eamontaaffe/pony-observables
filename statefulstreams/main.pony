"""
Pull based asynchronous streams...

References:
- Redis Streams
- Flink Stateful Streaming
"""

use "ponytest"
use "promises"

primitive Lower
primitive Upper

actor StatefulStream[A: Any #share]
  let _values: Array[(A | Lower | Upper)] =
    _values.create()

  be add(x: A) =>
    _values.push(x)

  be length(p: Promise[USize]) =>
    p(_values.size())

  // be range(
  //   p: Promise[Array[(ID, A)]],
  //   lower: (Minimum | ID),
  //   upper: (Maximum | ID),
  //   count: USize = 1000
  // ) =>

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(_TestUnit)

class iso _TestUnit is UnitTest
  fun name(): String => "Unit Tests"

  fun apply(h: TestHelper) =>
    h.long_test(1_000)

    let stream = StatefulStream[USize].create()

    let p = Promise[USize]

    p.next[None]({(x) => h.assert_eq[USize](0, x)})
     .next[None]({(_) => h.complete(true)})

    stream.length(p)
