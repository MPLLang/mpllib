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


```sml
val searchPosition: 'a Seq.t -> ('a -> order) -> int
```

`searchPosition s cmpTargetAgainst` finds a target position in the sequence
by using `cmpTargetAgainst` to point towards the target position. This is
useful when you aren't looking for a specific element, but some location
within a sequence. Note that this is more general than the plain `search`
function, because we can implement `search` in terms of
`searchPosition` as follows:
`fun search cmp s x = searchPosition s (fn y => cmp (x, y))`.

**Requires** the input sequence must be sorted w.r.t. `cmpTargetAgainst`.

Logarithmic work and span.


## Examples

Suppose `table: (key * value) seq` represents a mapping from keys to values,
and it is sorted by key. Here we use `searchPosition` to look up the value
associated with a particular key `target`:
```sml
fun lookup
  { table: (key * value) Seq.t
  , keyCmp: key * key -> order
  , target: key
  }
  : value option
=
  let
    val n = Seq.length table

    (** result of this call is an idx such that table[idx] contains the
      * target key, if the table contains the target key.
      *)
    val idx = BinarySearch.searchPosition table (fn k => keyCmp (target, k))
  in
    (** now we need to check if the table actually contains the key *)
    if idx = n then
      (** In this case, the target position is at the end of the sequence,
        * i.e., it is larger than any key in the table. So this key is
        * NOT in the table.
        *)
      NONE
    else
      (** In this case, the target position is somewhere in the middle of
        * the sequence. It may or may not be in the table though; we need to
        * inspect the key that is at table[idx]
        *)
      let
        val (k, v) = Seq.nth table idx
      in
        case keyCmp (target, k) of
          EQUAL => SOME v
        | _ => NONE
      end
  end
```
