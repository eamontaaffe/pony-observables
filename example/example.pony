use "../observables"

actor Main
  new create(env: Env) =>
    SimpleObservable[String]
      .fromSingleton("An elephant is an animal")
      // TODO: .apply[String](FlatMapOperator[String, String]({(scentence: String): String => scentence.split(" ").values())
      .apply[String](MapOperator[String, String]({(word: String): String => word.lower()}))
      // TODO: .apply[String](ReduceOperator[String, String](...))
      .subscribe(
        object is Observer[String]
          be onNext(value: String) =>
            env.out.print(value)
        end
      )
