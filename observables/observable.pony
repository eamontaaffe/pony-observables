use "itertools"

interface Observer[A: Any #share]
  be onNext(value: A)
  be onError()
  be onComplete()


trait Observable[A: Any #share]
  """
  Observables, inspired by ReactiveX.
  """
  be subscribe(observer: Observer[A] tag)

  // fun take(n: USize): Observable[A]
  // TODO:  fun map[B: Any #share](fn: {(A): B}): Observable[B] =>

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
