use "../observables"
use "collections/persistent"

actor Main
  new create(env: Env) =>
    SimpleObservable[String]
      .fromSingleton("An elephant is an animal")
      .apply[Array[String] val](
        MapOperator[String, Array[String] val](
          {(scentence) => scentence.split(" ")}
        )
      )
      .apply[String](FlattenOperator[String])
      .apply[String](MapOperator[String, String]({(word) => word.lower()}))
      .apply[Map[String, USize] val](
        ReduceOperator[String, Map[String, USize]](
          {(x, acc) => acc.update(x, acc.get_or_else(x, 0) + 1)},
          Map[String, USize].create()
        )
      )
      .subscribe(
        object is Observer[Map[String, USize]]
          be onNext(value: Map[String, USize]) =>
            for (k, v) in value.pairs() do
              env.out.print("('" + k + "', '" + v.string() + "')")
            end
        end
      )
