actor TakeOperator[C: Any #share] is (Observer[C] & Observable[C])
  let _max: USize
  var _count: USize = 0
  let _subscribers: Array[Observer[C] tag] = []

  new create(max: USize) =>
    _max = max

  be onNext(value: C) =>
    if _count < _max then
      for s in _subscribers.values() do
        s.onNext(value)
      end
    end

    _count = _count + 1

    if _count >= _max then
      onComplete()
    end

  be onComplete() =>
    for s in _subscribers.values() do
      s.onComplete()
    end

  be onError() =>
    for s in _subscribers.values() do
      s.onError()
    end

  be subscribe(observer: Observer[C] tag) =>
    _subscribers.push(observer)

