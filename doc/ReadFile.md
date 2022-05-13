# structure ReadFile

Note that the following functions are parallelized and will generally be
faster on more processors.

```sml
val contents: string -> string
```

`contents path` reads the file at `path` and returns its contents as a
string.

```sml
val contentsSeq: string -> char Seq.t
```

`contentsSeq path` reads the file at `path` and returns its contents as a
sequence of bytes represented as `char`s.

```sml
val contentsBinSeq: string -> Word8.word Seq.t
```

`contentsBinSeq path` reads the file at `path` and returns its contents as a
sequence of bytes represented as `Word8.word`s.
