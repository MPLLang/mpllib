# structure ForkJoin

```sml
val par: (unit -> 'a) * (unit -> 'b) -> 'a * 'b
```

`par (f, g)` runs `f()` and `g()` in parallel and returns
their results. The cost of `par` is O(1), but somewhat
substantial. Consider using granularity control to amortize this cost.


```sml
val parfor: int -> (int * int) -> (int -> unit) -> unit
```

`parfor grain (lo, hi) f` executes `f(i)` in parallel for
`lo <= i < hi`. (Note `lo` is inclusive on the bottom, and `hi` is
exclusive on the top.) The `grain` argument is for granularity control: the
loop is split into approximately `(hi-lo)/grain` subranges, each of
size at most `grain`.

```sml
val alloc: int -> 'a array
```

**Warning: unsafe**. Intended only for use in the implementation
of high-performance libraries.

`alloc n` produces a fresh array of the length `n`. The resulting array
has undefined contents, and must not be read until every index has been
initialized (e.g. with `Array.update`).
