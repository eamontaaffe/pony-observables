trait Observer[A: Any #share]
  be onNext(value: A)
  be onError()
  be onComplete()


trait Observable[A: Any #share]
  """
  Observables, inspired by ReactiveX.
  """
  be subscribe(observer: Observer[A] tag)

  fun map[B: Any #share](
    fn: {(A): B} val)
    : Observable[B] tag
  =>
    let obs: (Observable[B] tag & Observer[A] tag) =
      _MapTransform[A, B].create(fn)

    subscribe(obs)
    obs


actor SimpleObservable[A: Any #share] is Observable[A]
  let _subscribe: {(Observer[A] tag): None} val

  be subscribe(subscriber: Observer[A] tag) =>
    _subscribe(subscriber)

  new create(subscribe': {(Observer[A] tag): None} val) =>
    _subscribe = subscribe'

  new fromArray(xs: Array[A] val) =>
    _subscribe = {(subscriber: Observer[A] tag) =>
      for x in xs.values() do
        subscriber.onNext(x)
      end
      subscriber.onComplete()
    }
