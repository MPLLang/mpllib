# `structure Merge`

```sml
type 'a seq = 'a Seq.t
```

```sml
(** `writeMerge cmp (s, t) r` merges the sorted sequences `s` and `t`
  * in parallel and writes the resulting (sorted) sequence into `r`.
  * Requires that the input sequences are sorted with respect to the
  * comparison function `cmp` (and ensures that the output is, too).
  * Work: |s|+|t|
  * Span: polylog(|s| + |t|)
  *
  * `writeMergeSerial` is similar, except fully sequential.
  *)
val writeMerge:
  ('a * 'a -> order) -> 'a seq * 'a seq -> 'a seq -> unit
val writeMergeSerial:
  ('a * 'a -> order) -> 'a seq * 'a seq -> 'a seq -> unit
```

```sml
(** This functions are purely functional versions of the merge
  * functions, above.
  *)
val merge:
  ('a * 'a -> order) -> 'a seq * 'a seq -> 'a seq
val mergeSerial:
  ('a * 'a -> order) -> 'a seq * 'a seq -> 'a seq
```
