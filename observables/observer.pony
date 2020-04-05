interface Observer[A: Any #share]
  // TODO: be onSubscription(subscription: {() => None} iso) =>
    """
    An observable calls this method when the observer is first subscribed. This
    method will only be called once. It will be called with a function to 
    cancel the subscription as it's argument.
    """

  be onNext(value: A)
    """
    An Observable calls this method whenever the Observable emits an item. This
    method takes as a parameter the item emitted by the Observable.
    """

  be onComplete() =>
    """
    An Observable calls this method after it has called onNext for the final 
    time, if it has not encountered any errors.
    """
    None

  be onError() =>
    """
    An Observable calls this method to indicate that it has failed to generate
    the expected data or has encountered some other error. It will not make 
    further calls to onNext or onCompleted. The onError method takes as its 
    parameter an indication of what caused the error.
    """
    None

