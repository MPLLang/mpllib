# structure StableSort

```sml
type 'a seq = 'a Seq.t
```

We use the [`Seq`](Seq.md) representation of sequences for these functions.

```sml
val sortInPlace: ('a * 'a -> order) -> 'a seq -> unit
```

`sortInPlace cmp s` sorts `s` and writes the result in-place.
This is guaranteed to be *stable*: the relative order of equal elements is
preserved. The algorithm used is a merge-sort.

**Work**: `O(|s|log|s|)`

**Span**: `polylog|s|`

```sml
val sort: ('a * 'a -> order) -> 'a seq -> 'a seq
```

A purely functional version. The input is not modified; instead, a fresh
array is produced as output.
