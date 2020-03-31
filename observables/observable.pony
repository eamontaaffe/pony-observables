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
    let attach = _Then[A, B].map(fn)
    subscribe(attach.observer)
    attach.observable

  fun tag reduce[B: Any #share](fn: {(A, B): B} val, init: B): Observable[B] tag =>
    let attach = _Then[A, B].reduce(fn, init)
    subscribe(attach.observer)
    attach.observable


class _Then[C: Any #share, D: Any #share]
  """
  Wrapper class required as a workaround for:
  https://github.com/ponylang/ponyc/issues/1875

  TODO: Find a better pattern so that I don't need to wrap every transformation
  manually.
  """
  let observable: Observable[D] tag
  let observer: Observer[C] tag

  new map(fn: {(C): D} val) =>
    let transform = _MapTransform[C, D].create(fn)
    observable = transform
    observer = transform

  new reduce(fn: {(C, D): D} val, init: D) =>
    let transform = _ReduceTransform[C, D].create(fn, init)
    observable = transform
    observer = transform
