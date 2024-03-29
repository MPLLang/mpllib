structure CLA = CommandLineArgs
val n = CLA.parseInt "size" 1000000
val keys = CLA.parseInt "keys" 100
val seed = CLA.parseInt "seed" 15210
val numTests = CLA.parseInt "num-tests" 10
val printTimes = CLA.parseFlag "print-times"

val _ = print ("size " ^ Int.toString n ^ "\n")
val _ = print ("keys " ^ Int.toString keys ^ "\n")
val _ = print ("num-tests " ^ Int.toString numTests ^ "\n")
val _ = print ("print-times? " ^ (if printTimes then "yes" else "no") ^ "\n")

val _ =
  if keys * 10 < n then
    ()
  else
    print
      ("WARNING: lots of unique keys. We recommend to using a small number \
       \of keys relative to the number of elements, to encourage \
       \duplicates and stress stability\n")

fun err msg =
  ( TextIO.output (TextIO.stdErr, "ERROR: " ^ msg ^ "\n")
  ; OS.Process.exit OS.Process.failure
  )

(** NOTE: we'll ensure that the input is always two sorted sequences pasted
  * together. This lets us test `merge` in isolation as though it were a
  * general sort function.
  *)
fun janksort cmp s =
  let
    val left = Seq.take s n
    val right = Seq.drop s n

    val (result, tm) = Util.getTime (fn _ =>
      StableMergeLowSpan.merge cmp (left, right))
  in
    if not printTimes then () else print ("time " ^ Time.fmt 4 tm ^ "s\n");

    result
  end

structure CheckSort = CheckSort(val sort_func = janksort)

fun checkone testNum seed =
  let
    val keys1 = Mergesort.sort Int.compare
      (Seq.tabulate (fn i => Util.hash (seed + i) mod keys) n)
    val keys2 = Mergesort.sort Int.compare
      (Seq.tabulate (fn i => Util.hash (seed + n + i) mod keys) n)

    val input = Seq.append (keys1, keys2)

    val maybeError =
      CheckSort.check
        {compare = Int.compare, input = input, check_stable = true}

    fun msg s =
      "[" ^ Int.toString (testNum + 1) ^ "/" ^ Int.toString numTests ^ "]: " ^ s
  in
    case maybeError of
      NONE => ()
    | SOME e =>
        case e of
          CheckSort.LengthChange => err (msg "incorrect length")
        | CheckSort.MissingElem _ => err (msg "missing element")
        | CheckSort.Inversion _ => err (msg "not sorted")
        | CheckSort.Unstable _ => err (msg "not stable");

    print (msg "test passed" ^ "\n")
  end

val _ = Util.loop (0, numTests) seed (fn (seed, i) =>
  (checkone i seed; Util.hash seed))
