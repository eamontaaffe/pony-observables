actor MapOperator[C: Any #share, D: Any #share] is (Observer[C] & Observable[D])
  let _fn: {(C): D} val
  let _subscribers: Array[Observer[D] tag] = []

  new create(fn: {(C): D} val) =>
    _fn = fn

  be onNext(value: C) =>
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

  be subscribe(observer: Observer[D] tag) =>
    _subscribers.push(observer)

