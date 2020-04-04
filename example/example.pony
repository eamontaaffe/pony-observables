use "../observables"

actor Main
  new create(env: Env) =>
    SimpleObservable[String]
      .fromSingleton("An elephant is an animal")
      .flatMap({(sentence) => sentence.split(" ").values())
      .map[String]({(word) => word.lower()})
      .subscribe(
        object is Observer[String]
          be onNext(value: String) =>
            env.out.print(value)
        end
      )
