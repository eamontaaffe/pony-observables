use "promises"

actor Stream[A: Any #share]
  """
  Asynchronous functional stream implementation.

  Stream3 -> Stream2 -> Stream1 -> Stream0
  Stream3 = (Item1, (Item2, (Item3, Nil)))

  TODO:
  - Does this need to be an actor? Could it be a class?
  - How would read file stream look?
  - Write some helper functions to get some elements from the list in one
    shot. Like take(x: USize): Promise[Array[A]].
  - How do you express the end of a stream? Stream[None] maybe?
  """
  let _head: A
  let _fn: {(A): A} val
  var _tail: (_Pending | Stream[A]) = _Pending

  new create(fn': ({(A): A} val), head': A) =>
    _head = head'
    _fn = fn'

  be head(p: Promise[A]) =>
    p(_head)

  be tail(p: Promise[Stream[A]]) =>
    if _tail is _Pending then
      _tail = Stream[A].create(_fn, _fn(_head))
    end

    try p(_tail as Stream[A]) end
