use "files"

actor FileObservable is Observable[String]
  let _file: (File | FileError)


  new create(path: FilePath) =>
    match OpenFile(path)
    | let file: File =>
      _file = file
    else
      _file = FileError
    end

  be subscribe(observer: Observer[String] tag) =>
    try
      match _file
      | let file: File =>
        for line in (_file as File).lines() do
          observer.onNext(consume line)
        end
        observer.onComplete()
      else
        observer.onError()
      end
    end
