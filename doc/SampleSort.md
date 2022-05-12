# structure SampleSort

```sml
val sort: ('a * 'a -> order) -> 'a seq -> 'a seq
```

`sort cmp s` sorts `s` with respect to the order given by `cmp`, returning
the sorted sequence.

The algorithm here is based on the parallel sample-sort algorithm presented in:
> **Low depth cache-oblivious algorithms**.
> Guy E. Blelloch, Phillip B. Gibbons and  Harsha Vardhan Simhadri.
> SPAA 2010

The implementation here is provided by Guy Blelloch.
