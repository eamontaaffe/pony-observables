interface Observer[A: Any #share]
  be onNext(value: A)
  be onError()
  be onComplete()


interface Observable[A: Any #share]
  """
  Observables, inspired by ReactiveX.
  """
  be subscribe(observer: Observer[A] tag)

  fun tag map[B: Any #share](fn: {(A): B} val): Observable[B] tag =>
    let attach = _Then[A, B].create(fn)
    subscribe(attach.observable)
    attach.observable

class _Then[C: Any #share, D: Any #share]
  let observable: (Observable[D] tag & Observer[C] tag)

  new create(fn: {(C): D} val) =>
    observable = _MapTransform[C, D].create(fn)
