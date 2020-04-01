use "../observables"
use "ponybench"

actor Main is BenchmarkList
  new create(env: Env) =>
    PonyBench(env, this)

  fun tag benchmarks(bench: PonyBench) =>
    bench(_Nothing)


class iso _Nothing is MicroBenchmark
  fun name(): String => "nothing"

  fun apply() =>
    DoNotOptimise[None](None)
    DoNotOptimise.observe()



