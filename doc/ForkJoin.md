# `structure ForkJoin`

```sml
(** `par (f, g)` runs `f()` and `g()` in parallel and returns
  * their results. The cost of `par` is O(1), but somewhat
  * substantial, so you will need to do granularity control to
  * amortize this cost.
  *)
val par: (unit -> 'a) * (unit -> 'b) -> 'a * 'b
```

```sml
(** `parfor grain (lo, hi) f` executes `f(i)` in parallel for
  * `lo <= i < hi`. Note inclusive on the bottom, and exclusive
  * on the top. For granularity control, the range (lo, hi) is
  * split into approximately (hi-lo)/grain subranges, each of
  * size at most `grain`.
  *)
val parfor: int -> (int * int) -> (int -> unit) -> unit
```

```sml
(** WARNING: UNSAFE. Intended only for use in the implementation
  * of high-performance libraries.
  *
  * Allocates a fresh array of the given length. This is integrated
  * with the GC to be safe-for-GC and parallel. However, the resulting
  * contents of the array are not safe to read, and need to be
  * initialized.
  *)
val alloc: int -> 'a array
```
