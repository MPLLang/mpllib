# structure Quicksort

```sml
type 'a seq = 'a Seq.t
```

These functions use the [`Seq`](Seq.md) representation of sequences.

```sml
val sortInPlace: ('a * 'a -> order) -> 'a seq -> unit
```

`sortInPlace cmp s` sorts `s` and writes the result in-place.
Not guaranteed to be a stable sort (see [`StableSort`](StableSort.md)).

**Work**: `O(|s|log|s|)`

**Span**: `polylog|s|`

The algorithm is
[Vladimir Yaroslavskiy's dual-pivot quicksort](http://codeblab.com/wp-content/uploads/2009/09/DualPivotQuicksort.pdf). Implementation here provided by Guy Blelloch.

```sml
val sort: ('a * 'a -> order) -> 'a seq -> 'a seq
```

A purely functional version. The input is not modified; instead, a fresh
array is produced as output.
