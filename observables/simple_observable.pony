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

  new fromSingleton(x: A) =>
    _subscribe = {(subscriber: Observer[A] tag) =>
      subscriber.onNext(x)
      subscriber.onComplete()
    }
