interface Observable[A: Any #share]
  """
  Observables, inspired by ReactiveX.
  """
  be subscribe(observer: Observer[A] tag)

  fun tag apply[B: Any #share](operator: (Observer[A] tag & Observable[B] tag)): Observable[B] tag =>
    subscribe(operator)
    operator
