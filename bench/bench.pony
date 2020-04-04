use "../observables"
use "ponybench"
use "debug"

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
      .fromSingleton(_input)
      .subscribe(object is Observer[String]
        be onNext(value: String) => Debug.out(value)
        be onComplete() => c.complete()
        be onError() => c.fail()
      end)
