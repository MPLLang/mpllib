# structure Shuffle

```sml
val shuffle: 'a Seq.t -> int -> 'a Seq.t
```

`shuffle s seed` produces a pseudorandom permutation of `s` based on the
random seed `seed`.

For a particular seed, it will always produce
the same result. Any two shuffles (using two different seeds) are independent.
E.g. `shuffle s seed` is independent of `shuffle s (seed+1)`.

Linear work and polylogarithmic span.
