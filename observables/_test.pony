use "ponytest"

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(_TestUnit)


class iso _TestUnit is UnitTest
  fun name(): String => "SimpleObservable"

  fun apply(h: TestHelper) =>
    h.long_test(1_000)

    let o: Observable[USize] tag = SimpleObservable[USize].create({(subscriber) =>
      subscriber.onNext(1)
      subscriber.onComplete()
    })


    let observer: Observer[USize val] tag = object
      be onNext(x: USize) =>
        h.assert_eq[USize](x, 1)

      be onComplete() =>
        h.complete(true)

      be onError() =>
        h.complete(false)
    end

    o.subscribe(observer)
