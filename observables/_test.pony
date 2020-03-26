use "ponytest"
use "debug"

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(_TestFromSubscribe)
    test(_TestFromArray)
    test(_TestMapTransform)


class iso _TestFromSubscribe is UnitTest
  fun name(): String => "fromSubscribe"

  fun apply(h: TestHelper) =>
    h.long_test(1_000_000)

    let o = Observables.fromSubscribe[USize]({(subscriber) =>
        subscriber.onNext(1)
        subscriber.onComplete()
    })

    let observer = object
      be onNext(x: USize) =>
        Debug.out("onNext: " + x.string())
        h.assert_eq[USize](x, 1)

      be onComplete() =>
        h.complete(true)

      be onError() =>
        h.complete(false)
    end

    o.subscribe(observer)

class iso _TestFromArray is UnitTest
  fun name(): String => "fromArray"

  fun apply(h: TestHelper) =>
    h.long_test(1_000)

    let o = Observables.fromArray[USize]([1; 2; 3; 4; 5])

    let observer = object
      var _total: USize = 0

     be onNext(x: USize) =>
        _total = _total + x

      be onComplete() =>
        h.assert_eq[USize](15, _total)
        h.complete(true)

      be onError() =>
        h.complete(false)
    end

    o.subscribe(observer)

class iso _TestMapTransform is UnitTest
  fun name(): String => "map"

  fun apply(h: TestHelper) =>
    h.long_test(1_000)

    let o = Observables
      .fromArray[USize]([1; 2; 3; 4; 5])
      .map[USize]({(x) => x * 2})

    let observer = object
      var _total: USize = 0

     be onNext(x: USize) =>
        _total = _total + x

      be onComplete() =>
        h.assert_eq[USize](30, _total)
        h.complete(true)

      be onError() =>
        h.complete(false)
    end

    o.subscribe(observer)
