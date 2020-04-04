actor FlattenOperator[C: Any #share] is (Observer[Array[C] val] & Observable[C])
  let _subscribers: Array[Observer[C] tag] = []

  be onNext(value: Array[C] val) => None
    for s in _subscribers.values() do
      for v in value.values() do
        s.onNext(v)
      end
    end

  be onComplete() =>
    for s in _subscribers.values() do
      s.onComplete()
    end

  be onError() =>
    for s in _subscribers.values() do
      s.onError()
    end

  be subscribe(observer: Observer[C] tag) => None
    _subscribers.push(observer)
