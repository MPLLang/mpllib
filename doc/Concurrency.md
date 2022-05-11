# `structure Concurrency`

```sml
(** The number of processors specified at run-time. *)
val numberOfProcessors: int
```

```sml
(** `cas r (x, y)` performs an atomic compare-and-swap (CAS)
  * which attempts to atomically update the contents of `r` from
  * `x` to `y`, returning the original value stored in `r` before
  * the CAS. Polymorphic equality is determined in the same way as
  * MLton.eq (http://mlton.org/MLtonStructure), which is a standard
  * equality check for simple types (char, int, word, etc.) and a
  * pointer equality check for other types (array, string, tuples,
  * datatypes, etc.). The semantics are a bit murky.
  *)
val cas: 'a ref -> ('a * 'a) -> 'a
```

```sml
(** `casArray (a, i) (x, y)` is the same as `cas`, except the
  * CAS is performed on an array `a` at index `i`.
  *)
val casArray: ('a array * int) -> ('a * 'a) -> 'a
```
