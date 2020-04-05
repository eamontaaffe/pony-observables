use "ponytest"
use "debug"

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(_TestFromSubscribe)
    test(_TestFromArray)
    test(_TestMapOperator)
    test(_TestReduceOperator)
    test(_TestFromSingleton)
    test(_TestTakeOperator)
    test(_TestFlattenOperator)


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
    h.long_test(1_000_000)

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

class iso _TestMapOperator is UnitTest
  fun name(): String => "map"

  fun apply(h: TestHelper) =>
    h.long_test(1_000_000)

    let o: Observable[USize] tag =
      SimpleObservable[USize]
        .fromArray([1; 2; 3; 4; 5])
        .apply[USize](MapOperator[USize, USize]({(x) => x * 2}))

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

class iso _TestReduceOperator is UnitTest
  fun name(): String => "reduce"

  fun apply(h: TestHelper) =>
    h.long_test(1_000_000)

    let o: Observable[USize] tag =
      SimpleObservable[USize]
        .fromArray([1; 2; 3])
        .apply[USize](ReduceOperator[USize, USize]({(x, acc) => x + acc}, 0))

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
    h.long_test(1_000_000)

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

class iso _TestTakeOperator is UnitTest
  fun name(): String => "take"

  fun apply(h: TestHelper) =>
    h.long_test(1_000_000)

    let o =
      SimpleObservable[String]
        .fromArray(["The"; "quick"; "brown"; "fox"])
        .apply[String](TakeOperator[String](3))
        .apply[String](
          ReduceOperator[String, String]({(x, acc) => acc + x}, "")
        )

    let observer = object is Observer[String]
      be onNext(x: String) =>
        h.assert_eq[String]("Thequickbrown", x)

      be onComplete() =>
        h.complete(true)

      be onError() =>
        h.complete(false)
    end

    o.subscribe(observer)

class iso _TestFlattenOperator is UnitTest
  fun name(): String => "flatten"

  fun apply(h: TestHelper) =>
    h.long_test(1_000_000)

    let o =
      SimpleObservable[Array[String] val]
        .fromSingleton(["The"; "quick"; "brown"; "fox"])
        .apply[String](FlattenOperator[String])
        .apply[String](
          ReduceOperator[String, String]({(x, acc) => acc + x}, "")
        )

    let observer = object is Observer[String]
      be onNext(x: String) =>
        Debug.out(x)
        h.assert_eq[String]("Thequickbrownfox", x)

      be onComplete() =>
        Debug.out("onComplete")
        h.complete(true)

      be onError() =>
        h.complete(false)
    end


    o.subscribe(observer)
