# structure FindFirst

```sml
val findFirst : int -> (int * int) -> (int -> bool) -> int option
```

`findFirst grain (lo, hi) predicate` returns the smallest `i` in
the range `lo <= i < hi` for which `predicate(i)` is true. If no
such index satisfies the predicate, it returns `NONE`. The argument
`grain` is used for granularity control: each parallel task is assigned
approximately `grain` number of predicate calls. Values of `grain` less than 1 are
treated as 1.

The cost of `findFirst` depends on how large of a prefix it searches.
Let `n` be the size of this prefix: if the function returns `SOME i` then
`n = i-lo`, otherwise `n = hi-lo`.

**Work**: `O(n)`

**Span**: `polylog(n)`

```sml
val findFirstNondet : int -> (int * int) -> (int -> bool) -> int option
```

`findFirstNondet grain (lo, hi) predicate` computes the same result as
`findFirst grain (lo, hi) predicate`, but is typically faster. Like
`findFirst`, it begins with a sequential scan of `[lo, lo+grain)` and then
proceeds over chunks that double in size, each searched in parallel.
Unlike `findFirst`, the smallest index found so far is tracked in a shared
atomic counter (updated with a priority-update). Parallel tasks poll this
counter before splitting and abandon their range as soon as an earlier index
has been found.

The result is deterministic, but the amount of work performed (i.e., the
set of indices on which `predicate` is called) is not.

**Work**: `O(n)`

**Span**: `polylog(n)`

```sml
val findFirstSerial : (int * int) -> (int -> bool) -> int option
```

`findFirstSerial` is like `findFirst`, except that it is entirely
sequential.

**Work**: `O(n)`

**Span**: `O(n)`
