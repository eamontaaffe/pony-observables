interface Observer[A: Any #share]
  be onNext(value: A)
  be onError()
  be onComplete()


trait Observable[A: Any #share]
  """
  Observables, inspired by ReactiveX.
  """
  be subscribe(observer: Observer[A] tag)

  fun map[B: Any #share](fn: {(A): B} val): Observable[B] =>
    let o = object is Observable[A]
      let _subscribers: Array[Observer[B]] = _subscribers.create()

      be subscribe(subscriber: Observer[B]) =>
        _subscribers.push(subscriber)

      be onNext(value: A) =>
        for s in _subscribers do
          s.onNext(fn(value))
        end

      be onComplete() =>
        for s in _subscribers do
          s.onComplete()
        end

      be onError() =>
        for s in _subscribers do
          s.onError()
        end
    end

    subscribe(o)
    o

primitive Observables
  fun fromSubscribe[A: Any #share](
    subscribe': {(Observer[A] tag): None} val
  ): Observable[A] tag =>
    object is Observable[A]
      be subscribe(subscriber: Observer[A] tag) =>
        subscribe'(subscriber)
    end

  fun fromArray[A: Any #share](xs: Array[A] val): Observable[A] tag =>
    object is Observable[A]
      be subscribe(subscriber: Observer[A] tag) =>
        for x in xs.values() do
          subscriber.onNext(x)
        end
        subscriber.onComplete()
    end
