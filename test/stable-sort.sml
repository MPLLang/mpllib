structure CLA = CommandLineArgs
val n = CLA.parseInt "size" 1000000
val keys = CLA.parseInt "keys" 100
val seed = CLA.parseInt "seed" 15210
val numTests = CLA.parseInt "num-tests" 10

val _ = print ("size " ^ Int.toString n ^ "\n")
val _ = print ("keys " ^ Int.toString keys ^ "\n")
val _ = print ("num-tests " ^ Int.toString numTests ^ "\n")

val _ =
  if keys * 10 < n then () else
    print ("WARNING: lots of unique keys. We recommend to using a small number \
           \of keys relative to the number of elements, to encourage \
           \duplicates and stress stability\n")

fun err msg =
  ( TextIO.output (TextIO.stdErr, "ERROR: " ^ msg ^ "\n")
  ; OS.Process.exit OS.Process.failure
  )

structure CheckSort = CheckSort (val sort_func = StableSort.sort)

fun checkone testNum seed =
  let
    val input = Seq.tabulate (fn i => Util.hash (seed+i) mod keys) n
    val maybeError = CheckSort.check
      { compare = Int.compare
      , input = input
      , check_stable = true
      }

    fun msg s =
      "[" ^ Int.toString (testNum+1) ^ "/" ^ Int.toString numTests ^ "]: " ^ s
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
