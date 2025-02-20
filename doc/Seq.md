# `structure Seq`

Polymorphic immutable sequences, represented by array slices under the hood to
allow for constant-work random access and reindexing.
**All functions here have no side-effects**: they do not
modify their inputs and have no implicit state. All functions are also
deterministic, except where stated otherwise.
Contiguous subsequences (produced via `subseq`, `take`, and `drop`) share space
with their input: a sequence remains in memory as long as there is a reference
to it or one of its subsequences.

Parallel functions have an implicit (fairly large) granularity. For more
careful granularity control, see [`SeqBasis`](SeqBasis.md).

Note that `structure ArraySequence = Seq`; these structures are identical
and can be used interchangeably.

In the documentation below, some notational conventions:
  * `|s|` means `length s`
  * `s[i]` means `nth s i`
  * `[x,y,z]` means `fromList [x,y,z]`.

## Types

```sml
type 'a t
type 'a seq = 'a t
```

The sequence type, with elements of type `'a`.

## Lengths, Indexing, and Subsequences

All functions here require `O(1)` work and span.

```sml
val length: 'a seq -> int
```

The length of a sequence, i.e., number of elements.

```sml
val nth: 'a seq -> int -> 'a
```

`nth s i` returns the element at index `i` of `s`.
**Requires** `0 <= i < length s`.
Raises `Subscript` if out-of-bounds.


```sml
val first: 'a seq -> 'a
```

Get the element at index 0; raise `Subscript` if empty.

```sml
val last: 'a seq -> 'a
```

Get the element at index `n-1`; raise `Subscript` if empty.

```sml
val subseq: 'a seq -> int * int -> 'a seq
```

`subseq s (i, len)` returns the contiguous subsequence of elements
of length `len` starting at index `i`.
**Requires** `0 <= i <= i+len <= length s`.
Raises `Subscript` if either out-of-bounds or `len` is negative.


```sml
val take: 'a seq -> int -> 'a seq
```

`take s k` returns the first `k` elements of `s`.
Equivalent to `subseq s (0, k)`.


```sml
val drop: 'a seq -> int -> 'a seq
```

`drop s k` removes the first `k` elements of `s`.
Equivalent to `subseq s (k, length s - k)`.


## Construction

```sml
val empty: unit -> 'a seq
```

A fresh empty sequence.

```sml
val singleton: 'a -> 'a seq
val $ = singleton
```

Produce a sequence with a single element.

```sml
val tabulate: (int -> 'a) -> int -> 'a seq
```

`tabulate f n` produces the sequence `[f(0), f(1), ..., f(n-1)]`.

**Work**: `O(sum_i Work(f(i)))`

**Span**: `O(max_i Span(f(i)) + log(n))`


## Conversions

```sml
val fromList: 'a list -> 'a seq
val % = fromList
```

Converts a list into a sequence.
Linear work and span.


```sml
val fromRevList: 'a list -> 'a seq
```

Reverse a list and convert it into a sequence.
Linear work and span.


```sml
val toList: 'a seq -> 'a list
```

Converts a sequence into a list.
Linear work and span.


```sml
val toString: ('a -> string) -> 'a seq -> string
```

Produces a string representation of a sequence by first
converting each element using the provided function as argument.

Linear work and span.

For example:
> ```
> toString Int.toString (fromList [1,2,3])
> ==>
> "<1,2,3>"
> ```


## Concatenation and Reversal

```sml
val append: 'a seq * 'a seq -> 'a seq
```

Concatenates two sequences.
Linear work and logarithmic span.


```sml
val append3: 'a seq * 'a seq * 'a seq -> 'a seq
```

Concatenate three sequences.
Linear work and logarithmic span.

```sml
val flatten: 'a seq seq -> 'a seq
```

`flatten s` concatenates many sequences.

**Work**: `O(sum_i |s[i]|)`

**Span**: `O(log|s| + \max_i log|s[i]|)`

For example:
> ```
> flatten [[0,1,2],[],[3],[4,5],[]]
> ==>
> [0,1,2,3,4,5]
> ```


```sml
val rev: 'a seq -> 'a seq
```

Reverse the elements of a sequence.
Linear work and logarithmic span.

## Maps and Zips

```sml
val map: ('a -> 'b) -> 'a seq -> 'b seq
```

`map f s` applies `f` to each element to produce
a new sequenece `[f(s[0]), f(s[1]), ...]`.

**Work**: `O(sum_i Work(f(s[i])))`

**Span**: `O(max_i Span(f(s[i])) + log|s|)`


```sml
val mapIdx: (int * 'a -> 'b) -> 'a seq -> 'b seq
```

The same as `map`, but the function should expect argument pairs
`(i,v)` where `v` is the element at index `i`.


```sml
val enum: 'a seq -> (int * 'a) seq
```

Pair each element with its index.
Equivalent to `mapIdx (fn (i, x) => (i,x))`.
Linear work and logarithmic span.


```sml
val zipWith: ('a * 'b -> 'c) -> 'a seq * 'b seq -> 'c seq
```

`zipWith f (s, t)` produces `[f(s[0], t[0]), f(s[1], t[1]), ...]`.
That is, it applies function `f` to pairs of elements at the same index.
The resulting sequence has length `min(|s|,|t|)`. The work and span are
asymptotically the same as `map f (zip (s, t))` but the performance in
practice will be faster.


```sml
val zipWith3: ('a * 'b * 'c -> 'd) -> 'a seq * 'b seq * 'c seq -> 'd seq
```

Same as `zipWith`, but for three sequences instead of two.

```sml
val zip: 'a seq * 'b seq -> ('a * 'b) seq
```

A standard zip. Equivalent to `zipWith (fn (x,y) => (x,y))`.
Linear work and logarithmic span w.r.t. the output length `min(|s|,|t|)`.

## Parallel Aggregation

```sml
val reduce: ('a * 'a -> 'a) -> 'a -> 'a seq -> 'a
```

`reduce f z s` computes the "sum" of `s` with respect to `f`.
Requires that `f` is associative with corresponding identity
`z`. When `s` is empty, this returns `z`.

Assuming f is O(1):

**Work**: `O(|s|)`

**Span**: `O(log|s|)`

For example:
> ```
> reduce op+ 0 [1,2,3,4,5]  ==>  15
> reduce op* 1 [1,2,3,4,5]  ==>  120
> reduce op^ "" ["a","b","c"]  ==>  "abc"
> ```


```sml
val scan: ('a * 'a -> 'a) -> 'a -> 'a seq -> 'a seq * 'a
```

`scan f z s` is like reduce, except it also computes the "sum"
of every prefix of `s`. The output is `(p, t)` where `p[i]` is the
sum of the first `i` elements, and `t` is the total sum (equivalent
to reduce).

Assuming f is O(1):

**Work**: `O(|s|)`

**Span**: `O(polylog|s|)`

For example:
> ```
> scan op+ 0 [1,2,3,4,5]  ==>  ([0,1,3,6,10],15)
> scan op* 1 [1,2,3,4,5]  ==>  ([1,1,2,6,24],120)
> scan op^ "" ["a","b","c"]  ==>  (["","a","ab"],"abc")
> ```

## TODO

filter, iterate, foldl/r, inject, foreach, etc.
