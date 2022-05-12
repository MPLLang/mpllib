# structure Merge

```sml
type 'a seq = 'a Seq.t
```

We use the [`Seq`](Seq.md) representation of sequences for these functions.

```sml
val writeMerge: ('a * 'a -> order) -> 'a seq * 'a seq -> 'a seq -> unit
val writeMergeSerial: ('a * 'a -> order) -> 'a seq * 'a seq -> 'a seq -> unit
```

`writeMerge cmp (s, t) r` merges the sorted sequences `s` and `t`
in parallel and writes the resulting (sorted) sequence into `r`.

**Requires** the input sequences are sorted with respect to the
comparison function `cmp` (and ensures that the output is, too).

**Work**: `O(|s|+|t|)`

**Span**: `polylog(|s| + |t|)`

`writeMergeSerial` is similar, except fully sequential.

```sml
val merge: ('a * 'a -> order) -> 'a seq * 'a seq -> 'a seq
val mergeSerial: ('a * 'a -> order) -> 'a seq * 'a seq -> 'a seq
```

These functions are purely functional versions of the `writeMerge` and
`writeMergeSerial` functions, described above. Rather than taking an
output sequence as argument, they instead produce a fresh sequence of
the result.
