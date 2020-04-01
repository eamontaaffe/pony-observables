use "../observables"
use "ponybench"

actor Main is BenchmarkList
  new create(env: Env) =>
    PonyBench(env, this)

  fun tag benchmarks(bench: PonyBench) =>
    bench(_WordCount("An elephant is an animal"))
    bench(_WordCount("Wombats eat all day long"))
    bench(_WordCount("All work and no play makes Jack a dull boy"))


class iso _WordCount is MicroBenchmark
  let _input: String

  new iso create(input: String) =>
    _input = input

  fun name(): String => "_WordCount('" + _input + "')"

  fun apply() =>
    DoNotOptimise[None](_run(_input))
    DoNotOptimise.observe()

  fun _run(input: String) =>
    SimpleObservable[String]
      .fromSingleton(input)
      // TODO: .flatMap({(sentence) => sentence.split(" ")})
      .map[String]({(word) => word.lower()})
      .reduce[USize]({(x: String, acc: USize): USize => acc + 1} val, 0)
      // TODO: Better reduce which counts how many of each individual word
