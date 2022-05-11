# `structure StableSort`

```sml
type 'a seq = 'a Seq.t
```

```sml
(** `sortInPlace cmp s` sorts `s` and writes the result in-place.
  * This is guaranteed to be stable: the relative order of "equal"
  * elements is preserved.
  * Work: |s|log|s|
  * Span: polylog|s|
  *)
val sortInPlace: ('a * 'a -> order) -> 'a seq -> unit
```

```sml
(** Purely functional version. *)
val sort: ('a * 'a -> order) -> 'a seq -> 'a seq
```
