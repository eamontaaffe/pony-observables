interface Observer[A: Any #share]
  be onNext(value: A)
  be onError()
  be onComplete()


trait Observable[A: Any #share]
  """
  Observables, inspired by ReactiveX.
  """
  be subscribe(observer: Observer[A] tag)

// TODO: fun take(n: USize): Observable[A]
// TODO:  fun map[B: Any #share](fn: {(A): B}): Observable[B] =>


actor SimpleObservable[A: Any #share] is Observable[A]
  let _subscribe: {(Observer[A] tag): None}

  new create(subscribe': {(Observer[A] tag): None} iso) =>
    _subscribe = consume subscribe'

  be subscribe(observer: Observer[A] tag) =>
    _subscribe(observer)
