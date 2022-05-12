# structure CountingSort

```sml
val sort: 'a seq -> (int -> int) -> int -> 'a seq * int seq
```

This function assigns each element to a bucket and groups elements
from the same bucket so that they are adjacent. In `sort s b n`, the function
`b` assigns bucket identifiers (where `b(i)` is the bucket of the `i`th
input element), and `n` is the number of buckets. The result
is the pair `(buckets, offsets)` where `offsets[i]` is the offset of the
`i`th bucket within `buckets`.

**Requires**: `0 <= b(i) < n` for every `0 <= i < |s|`.

Implementation by Guy Blelloch.

## Example

The following groups a collection of integers into 100 buckets,
according a hash function. After calling `CountingSort.sort`, it then uses
the resulting offsets to construct a sequence for each bucket.

```sml
fun bucketElementsByHash (elems: int Seq.t) : int Seq.t Seq.t =
  let
    val numElems = Seq.length elems
    val numBuckets = 100
    fun bucketId i =
      Util.hash (Seq.nth elems i) mod numBuckets

    val (sorted, offsets) = CountingSort.sort elems bucketId numBuckets

    (* size of ith bucket *)
    fun bucketSize i =
      if i+1 < numBuckets then
        Seq.nth offsets (i+1) - Seq.nth offsets i
      else
        numElems - Seq.nth offsets i

    fun makeBucket i =
      Seq.subseq sorted (i, bucketSize i)
  in
    Seq.tabulate makeBucket numBuckets
  end
```
