actor _MapTransform[X: Any #share, Y: Any #share] is (Observer[X] & Observable[Y])
  let _subscribers: Array[Observer[Y] tag] = _subscribers.create()
  let _fn: {(X): Y} val

  new create(fn: {(X): Y} val) =>
    _fn = fn

  be subscribe(observer: Observer[Y] tag) =>
    _subscribers.push(observer)

  be onNext(value: X) =>
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
