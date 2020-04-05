use "../observables"
use "ponybench"
use "debug"
use "collections/persistent"

actor Main is BenchmarkList
  new create(env: Env) =>
    PonyBench(env, this)

  fun tag benchmarks(bench: PonyBench) =>
    bench(_WordCount("An elephant is an animal"))
    bench(_WordCount("Wombats eat all day long"))
    bench(_WordCount("All work and no play makes Jack a dull boy"))


class iso _WordCount is AsyncMicroBenchmark
  let _input: String

  new iso create(input: String) =>
    _input = input

  fun name(): String => "_WordCount('" + _input + "')"

  fun apply(c: AsyncBenchContinue) =>
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
              Debug.out("('" + k + "', '" + v.string() + "')")
            end
          be onComplete() => c.complete()
          be onError() => c.fail()
        end
      )
