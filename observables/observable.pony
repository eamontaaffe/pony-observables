interface Observable[A: Any #share]
  """
  Observables, inspired by ReactiveX.
  """
  be subscribe(observer: Observer[A] tag)

  fun tag apply[B: Any #share](operator: (Observer[A] tag & Observable[B] tag)): Observable[B] tag =>
    subscribe(operator)
    operator

  fun tag map[B: Any #share](fn: {(A): B} iso): Observable[B] tag =>
    apply[B](_Operators[A, B].map(consume fn).inner)

  fun tag reduce[B: Any #share](
    fn: {(A, B): B} iso,
    init: B
  ): Observable[B] tag =>
    apply[B](_Operators[A, B].reduce(consume fn, init).inner)

//  fun tag flatten[B: Any #share](fn: {(A): Iterator[B]} val): Observable[B] tag =>
//    apply[B](_FlatMapOperator[A, B].flatMap(fn))


class _Operators[X: Any #share, Y: Any #share]
  """
  Wrapper class required as a workaround for:
  https://github.com/ponylang/ponyc/issues/1875

  TODO: Find a better pattern so that we don't need to wrap every 
  transformation manually. Or fix the issue #1875 so we dont need a workaround
  at all.
  """

  let inner: (Observer[X] tag & Observable[Y] tag)

  new map(fn: {(X): Y} iso) =>
    inner = MapOperator[X, Y](consume fn)

  new reduce(fn: {(X, Y): Y} iso, init: Y) =>
    inner = ReduceOperator[X, Y](consume fn, init)

//   new flatten() =>
//     inner = FlattenOperator[Y]

//   new take(x: USize) =>
//     inner = TakeOperator[Y](x)
