structure CLA = CommandLineArgs
val n = CLA.parseInt "size" 1000000
val keys = CLA.parseInt "keys" 100
val seed = CLA.parseInt "seed" 15210

fun kcmp (a, b) = Int.compare (a, b)
fun vcmp (u, v) = Int.compare (u, v)
fun cmp ((a, _), (b, _)) = kcmp (a, b)

val elems = Seq.tabulate (fn i => (Util.hash (seed+i) mod keys, i)) n

val result = StableSort.sort cmp elems

val _ = print ("result: " ^ Util.summarizeArraySlice 10 (fn (k, v) => "(" ^ Int.toString k ^ "," ^ Int.toString v ^ ")") result ^ "\n")

fun err msg =
  (print ("ERROR: " ^ msg ^ "\n"); OS.Process.exit OS.Process.failure)

fun checkloop (prevKey, prevVal) i =
  if i >= Seq.length result then ()
  else
    let
      val (key, value) = Seq.nth result i
      fun continue () = checkloop (key, value) (i+1)
    in
      case kcmp (prevKey, key) of
        LESS => continue ()
      | GREATER => err "not merged properly"
      | EQUAL =>
          case vcmp (prevVal, value) of
            LESS => continue ()
          | GREATER => err "not stable"
          | EQUAL => err "bug in test (should be impossible)"
    end

val _ = checkloop (~1, ~1) 0
val _ = print ("TEST PASSED\n")
