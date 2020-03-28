interface Observer[A: Any #share]
  be onNext(value: A)
  be onError()
  be onComplete()


interface Observable[A: Any #share]
  """
  Observables, inspired by ReactiveX.
  """
  be subscribe(observer: Observer[A] tag)

  fun tag map(fn: {(A): A} val): Observable[A] tag =>
    let obs = _MapTransform[A, A].create(fn)
    subscribe(obs)
    obs
