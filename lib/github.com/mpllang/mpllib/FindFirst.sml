structure FindFirst :
sig
  val findFirstSerial : (int * int) -> (int -> bool) -> int option

  (* findFirst granularity (start, end) predicate *)
  val findFirst : int -> (int * int) -> (int -> bool) -> int option

  (* findFirstNondet granularity (start, end) predicate *)
  val findFirstNondet : int -> (int * int) -> (int -> bool) -> int option
end =
struct

  fun findFirstSerial (i, j) p =
    if i >= j then NONE
    else if p i then SOME i
    else findFirstSerial (i+1, j) p

  fun optMin (a, b) =
    case (a, b) of
      (SOME x, SOME y) => (SOME (Int.min (x, y)))
    | (NONE, _) => b
    | (_, NONE) => a

  fun findFirst grain (lo, hi) p =
    let
      val grain = Int.max (1, grain)

      fun try (i, j) =
        if j - i <= grain then
          findFirstSerial (i, j) p
        else
          SeqBasis.reduce grain optMin NONE (i, j)
          (fn k => if p k then SOME k else NONE)

      fun loop (i, j) =
        if i >= j then NONE else
        case try (i, j) of
          NONE => loop (j, Int.min (j + 2*(j-i), hi))
        | SOME x => SOME x
    in
      loop (lo, Int.min (lo+grain, hi))
    end


  (* Searches the first `grain` indices [lo, lo+grain) sequentially, then
   * proceeds over chunks that double in size: [lo+grain, lo+3*grain),
   * [lo+3*grain, lo+7*grain), ... Each chunk is searched in parallel with
   * leaves of size `grain`.
   *
   * Within a chunk, the smallest index found so far is tracked in a shared
   * atomic counter (updated with a priority-update / write-min). Before
   * splitting a range, the search polls the counter and abandons the range
   * if a smaller index has already been found. Leaves also stop scanning
   * at the current minimum.
   *
   * The result is always the smallest satisfying index (deterministic);
   * only the amount of work performed is nondeterministic.
   *)
  fun findFirstNondet grain (lo, hi) p =
    let
      val grain = Int.max (1, grain)

      (* smallest satisfying index found so far; hi means "none yet" *)
      val best = ref hi

      fun writeMin x =
        let
          val cur = !best
        in
          if x >= cur then ()
          else if Concurrency.cas best (cur, x) = cur then ()
          else writeMin x
        end

      fun search (i, j) =
        let
          val j = Int.max (i, Int.min (j, !best))
        in
          if j - i <= grain then
            case findFirstSerial (i, j) p of
              NONE => ()
            | SOME x => writeMin x
          else
            let
              val mid = i + (j - i) div 2
            in
              ForkJoin.par (fn _ => search (i, mid), fn _ => search (mid, j));
              ()
            end
        end

      fun loop (i, j) =
        if i >= j then NONE
        else
          ( search (i, j)
          ; if !best < hi then SOME (!best)
            else loop (j, Int.min (j + 2 * (j - i), hi))
          )
    in
      loop (lo, Int.min (lo + grain, hi))
    end

end
