# structure Concurrency

```sml
val numberOfProcessors: int
```

The number of processors specified at run-time (with `@mpl procs ... --`).

```sml
val cas: 'a ref -> ('a * 'a) -> 'a
```

`cas r (x, y)` performs an atomic
[compare-and-swap (CAS)](https://en.wikipedia.org/wiki/Compare-and-swap).
If `!r` is equal to `x`, then it sets `r := y` and returns the overwritten
value. Otherwise, it returns the current contents of `r`. This happens
atomically (no other process is capable of updating `r` in the middle).

Polymorphic equality is determined in the same way as
[`MLton.eq`](http://mlton.org/MLtonStructure). That is, if
`MLton.eq (x, cas r (x, y))` is true, then the CAS succeeded.
This is a physical equality test: a straightforward equality test
for simple types (char, int, word, etc.) and a pointer equality check for
other types (array, string, tuples, datatypes, etc.). The semantics are a bit
murky: two copies of the same data are not necessarily equal.

This weak form of equality is still good enough for typical
uses of CAS. A common idiom is to (1) read the current value of
the ref, (2) update it in some manner, (3) CAS the new value
into the ref, and finally (4) retry if the CAS fails. The primitive `cas`
here might fail spuriously due to physical equality failure; in this case,
using the value returned from the failed CAS will then guarantee that on
the second attempt, there won't be a physical equality failure. (There could
still be a failure due to a concurrent update.)

**Note**: with SML/NJ, the type of `cas` is restricted to equality types:
`''a ref -> (''a * ''a) -> ''a`.

```sml
val casArray: ('a array * int) -> ('a * 'a) -> 'a
```

`casArray (a, i) (x, y)` is the same as `cas`, except the
CAS is performed on an array `a` at index `i`.

**Note**: with SML/NJ, the type of `casArray` is restricted to equality types:
`(''a array * int) -> (''a * ''a) -> ''a`.