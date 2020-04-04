actor TakeOperator[C: Any #share] is (Observer[C] & Observable[Array[C] val])
  """
  TODO: This isn't really a "take" operator, it's more like a chunk operator. 
  A take operator should return the first x elements then call onComplete. 
  Whereas a chunk operator will return each x elements as an array like I have
  done here.
  """
  let _size: USize
  var _values: Array[C] iso = []
  let _subscribers: Array[Observer[Array[C] val] tag] = []

  new create(size: USize) =>
    _size = size

  be _flush() =>
    let values_iso: Array[C] val = _values = []
    let values_val: Array[C] val = consume values_iso
    for s in _subscribers.values() do
      s.onNext(values_val)
    end

  be onNext(value: C) => None
    _values.push(value)
    if (_values.size() >= _size) then
      _flush()
    end

  be onComplete() =>
    _flush()
    for s in _subscribers.values() do
      s.onComplete()
    end

  be onError() =>
    _flush()
    for s in _subscribers.values() do
      s.onError()
    end

  be subscribe(observer: Observer[Array[C] val] tag) =>
    _subscribers.push(observer)

