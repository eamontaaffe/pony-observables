interface Observer[A: Any #share]
  be onNext(value: A)
  be onError()
  be onComplete()

trait Observable[A: Any #share]
  """
  Observables, inspired by ReactiveX.
  """
  be subscribe(observer: Observer[A] tag)


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

actor MapObservable[A: Any #share, B: Any #share] is Observable[A]
  let _subscribers: Array[Observer[A] tag] = _subscribers.create()
  let _fn: {(B): A} val

  new create(o: Observable[B] tag, fn': {(B): A} val) =>
    o.subscribe(this)
    _fn = fn'

  be subscribe(subscriber: Observer[A] tag) =>
    _subscribers.push(subscriber)

  be onNext(x: B) =>
    for s in _subscribers.values() do
      s.onNext(_fn(x))
    end

  be onComplete() =>
    for s in _subscribers.values() do
      s.onComplete()
    end

  be onError() =>
    for s in _subscribers.values() do
      s.onError()
    end
