use "../observables"
use collections = "collections"
use "collections/persistent"
use "files"
use "debug"

actor Main
  new create(env: Env) =>
    """
    Open the filename supplied as a command line argument and count the number
    of occurences of each word.
    """
    try
      let file_name: String = env.args(1) ?
      Debug.out("File name: " + file_name)
      let path = FilePath(
        env.root as AmbientAuth,
        file_name
      ) ?
      count_words(env, path)
    end

  fun count_words(env: Env, path: FilePath) =>
    FileObservable(path)
      .apply[Array[String] val](
        MapOperator[String, Array[String] val](
          {(scentence) => scentence.split(".,; \n")}
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
            var total_words: USize = 0
            for (k, v) in value.pairs() do
              env.out.print("('" + k + "', '" + v.string() + "')")
              total_words = total_words + v
            end
            env.out.print("Total words: " + total_words.string())
        end
      )
