actor ReduceOperator[X: Any #share, Y: Any #share] is (Observer[X] & Observable[Y])
  let _subscribers: Array[Observer[Y] tag] = _subscribers.create()
  let _fn: {(X, Y): Y}
  var _acc: Y

  new create(fn: {(X, Y): Y} iso, init: Y) =>
    _fn = consume fn
    _acc = init

  be subscribe(observer: Observer[Y] tag) =>
    _subscribers.push(observer)

  be onNext(value: X) =>
    _acc = _fn(value, _acc)

  be onComplete() =>
    for s in _subscribers.values() do
      s.onNext(_acc)
      s.onComplete()
    end

  be onError() =>
    for s in _subscribers.values() do
      s.onError()
    end
