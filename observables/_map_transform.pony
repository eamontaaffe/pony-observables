actor _MapTransform[A: Any #share, B: Any #share] is (Observer[A] & Observable[B])

  let _subscribers: Array[Observer[B] tag] = _subscribers.create()
  let _fn: {(A): B} val

  new create(fn': {(A): B} val) =>
    _fn = fn'

  be subscribe(observer: Observer[B] tag) =>
     _subscribers.push(observer)

  be onNext(value: A) =>
    for s in _subscribers.values() do
      s.onNext(_fn(value))
    end

  be onComplete() =>
    for s in _subscribers.values() do
      s.onComplete()
    end

  be onError() =>
    for s in _subscribers.values() do
      s.onError()
    end
