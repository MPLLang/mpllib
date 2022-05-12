# structure FindFirst

```sml
val findFirst : int -> (int * int) -> (int -> bool) -> int option
```

`findFirst grain (lo, hi) predicate` returns the smallest `i` in
the range `lo <= i < hi` for which `predicate(i)` is true. If no
such index satisfies the predicate, it returns `NONE`. The argument
`grain` is used for granularity control: each parallel task is assigned
approximately `grain` number of predicate calls.

The cost of `findFirst` depends on how large of a prefix it searches.
Let `n` be the size of this prefix: if the function returns `SOME i` then
`n = i-lo`, otherwise `n = hi-lo`.

**Work**: `O(n)`

**Span**: `polylog(n)`

```sml
val findFirstSerial : (int * int) -> (int -> bool) -> int option
```

`findFirstSerial` is like `findFirst`, except that it is entirely
sequential.

**Work**: `O(n)`

**Span**: `O(n)`
