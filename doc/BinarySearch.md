# structure BinarySearch

```sml
val search: ('a * 'a -> order) -> 'a Seq.t -> 'a -> int
```

`search cmp s x` finds the index of `x` within the sorted sequence
`s`. That is, it returns an index `i` such that `cmp(s[i],x) = EQUAL`,
if such an element exists. Otherwise, it counts the number of elements
strictly less than `x` according to `cmp`.

**Requires** the input sequence must be sorted w.r.t. `cmp`.

Logarithmic work and span.


```sml
val countLess: ('a * 'a -> order) -> 'a Seq.t -> 'a -> int
```

`countLess cmp s x` returns the number of elements strictly smaller than
`x` within the sorted sequence `s`. This is similar to `search`, except
with a stronger guarantee: if there are multiple elements that are all equal
according to `cmp`, then this will find the "leftmost" one.

**Requires** the input sequence must be sorted w.r.t. `cmp`.

Logarithmic work and span.
