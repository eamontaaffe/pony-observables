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
    let obs: (Observer[A] tag & Observable[B] tag) = _MapTransform[A, B].create(fn)
    subscribe(obs)
    obs
