use "ponytest"

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(_TestSimpleObservable)


class iso _TestSimpleObservable is UnitTest
  fun name(): String => "SimpleObservable"

  fun apply(h: TestHelper) =>
    h.long_test(1_000)

    let o = object is Observable[USize]
      be subscribe(subscriber: Observer[USize] tag) =>
        subscriber.onNext(1)
        subscriber.onComplete()
    end

    let observer = object
      be onNext(x: USize) =>
        h.assert_eq[USize](x, 1)

      be onComplete() =>
        h.complete(true)

      be onError() =>
        h.complete(false)
    end

    o.subscribe(observer)
