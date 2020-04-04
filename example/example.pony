use "../observables"
use "collections"

actor Main
  new create(env: Env) =>
    SimpleObservable[String]
      .fromSingleton("An elephant is an animal")
      .apply[Array[String] val](MapOperator[String, Array[String] val]({(scentence) => scentence.split(" ")}))
      .apply[String](FlattenOperator[String])
      .apply[String](MapOperator[String, String]({(word) => word.lower()}))
      .apply[Map[String, USize] val](ReduceOperator[String, Map[String, USize] val]({(x, acc) => Map[String, USize].create()}))
      .subscribe(
        object is Observer[Map[String, USize]]
          be onNext(value: String) =>
            env.out.print(value.string())
        end
      )
