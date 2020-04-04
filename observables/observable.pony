interface Observer[A: Any #share]
  // TODO: be onSubscription(subscription: Subscription iso) => None
  be onNext(value: A)
  be onComplete() => None
  be onError() => None


interface Observable[A: Any #share]
  """
  Observables, inspired by ReactiveX.
  """
  be subscribe(observer: Observer[A] tag)

 fun tag apply[B: Any #share](operator: (Observer[A] tag & Observable[B] tag)): Observable[B] tag =>
   subscribe(operator)
   operator

//  fun tag map[B: Any #share](fn: {(A): B} val): Observable[B] tag =>
//    apply[B](_MapOperator[A, B].create(fn))

//  fun tag reduce[B: Any #share](fn: {(A, B): B} val, init: B): Observable[B] tag =>
//    apply[B](_ReduceOperator[A, B].create(fn, init))

//  fun tag flatMap[B: Any #share](fn: {(A): Iterator[B]} val): Observable[B] tag =>
//    apply[B](_FlatMapOperator[A, B].flatMap(fn))
