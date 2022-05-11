# structure DelayedSeq

An implementation of parallel block-delayed sequences, as presented in
the paper:
> [**Parallel Block-Delayed Sequences**](https://dl.acm.org/doi/10.1145/3503221.3508434).
> Sam Westrick, Mike Rainey, Daniel Anderson, Guy E. Blelloch.
> PPoPP'22

The interface is the same as [`Seq`](Seq.md). The difference is that delayed
sequences avoid allocating temporary intermediate arrays, to improve
performance. In general, most pipelines of operations such as
`map`, `zip`, `reduce`, `scan`, `filter`, and `flatten` will be more
efficient with `DelayedSeq` than with `Seq`.

The intended usage is to first convert a sequence to a delayed version
with `DelayedSeq.fromArraySeq`, then perform a pipeline, and finally
(if there is some output sequence) convert the result back to a normal
sequence with `DelayedSeq.toArraySeq`.

## Examples

```sml
structure DS = DelayedSeq

(** Compute the sum of non-negative elements of `s`.
  * We don't need to use DS.toArraySeq at the end, because
  * the result is just an integer.
  *)
fun sumNonNegative (s: int Seq.t) =
  DS.reduce op+ 0
    (DS.map (fn x => Int.max (0, x))
      (DS.fromArraySeq s))


(** For example:
  *   evenMultiplesUpto 21 [3,5]  ==>  [6,12,18,10,20]
  *)
fun evenMultiplesUpto (n: int) (s: int Seq.t) =
  let
    fun multiples x =
      let
        val numMultiples = n div x - 1
      in
        DS.tabulate (fn i => (i+2)*x) numMultiples
      end
  in
    DS.toArraySeq (DS.filter (fn x => x mod 2 = 0)
      (DS.flatten (DS.map multiples (DS.fromArraySeq s))))
  end
```
