use "ponytest"
use "debug"

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(_TestFromSubscribe)
    test(_TestFromArray)
    test(_TestMapTransform)
    test(_TestReduceTransform)
    test(_TestFromSingleton)


class iso _TestFromSubscribe is UnitTest
  fun name(): String => "fromSubscribe"

  fun apply(h: TestHelper) =>
    h.long_test(1_000_000)

    let o: Observable[USize] tag = SimpleObservable[USize].create({(subscriber) =>
        subscriber.onNext(1)
        subscriber.onComplete()
    })

    let observer = object is Observer[USize]
      be onNext(x: USize) =>
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

    let o = SimpleObservable[USize].fromArray([1; 2; 3; 4; 5])

    let observer = object is Observer[USize]
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

    let o: Observable[USize] tag =
      SimpleObservable[USize]
        .fromArray([1; 2; 3; 4; 5])
        .map[USize]({(x: USize): USize => x * 2})

    let observer = object is Observer[USize]
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

class iso _TestReduceTransform is UnitTest
  fun name(): String => "reduce"

  fun apply(h: TestHelper) =>
    h.long_test(1_000)

    let o: Observable[USize] tag =
      SimpleObservable[USize]
        .fromArray([1; 2; 3])
        .reduce[USize]({(x: USize, acc: USize): USize => x + acc}, 0)

    let observer = object is Observer[USize]
      be onNext(x: USize) =>
        h.assert_eq[USize](6, x)

      be onComplete() =>
        h.complete(true)

      be onError() =>
        h.complete(false)
    end

    o.subscribe(observer)

class iso _TestFromSingleton is UnitTest
  fun name(): String => "singleton"

  fun apply(h: TestHelper) =>
    h.long_test(1_000)

    let o: Observable[String] tag =
      SimpleObservable[String]
        .fromSingleton("Hello, world!")

    let observer = object is Observer[String]
      be onNext(x: String) =>
        h.assert_eq[String]("Hello, world!", x)

      be onComplete() =>
        h.complete(true)

      be onError() =>
        h.complete(false)
    end

    o.subscribe(observer)
