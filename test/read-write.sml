fun makeTempName () =
  let
    val big = 1000 * 1000 * 1000
    val seed = 
      Int.fromLarge (Time.toMicroseconds (Time.now ()) mod LargeInt.fromInt big)
    val seed = Util.hash seed mod big
    val seedStr = Int.fmt StringCvt.HEX seed
  in
    "tmp" ^ seedStr
  end

(* ===================================================================== *)

val path = CommandLineArgs.parseString "tmp" (makeTempName ())
val n = CommandLineArgs.parseInt "n" 100000
val seed = CommandLineArgs.parseInt "seed" 15210
val seed = Util.hash seed

fun elem i =
  if (i+1) mod 81 = 0 then #"\n"
  else Char.chr (Char.ord #"a" + Util.hash (seed + i) mod 26)

val stuff = ArraySlice.full (SeqBasis.tabulate 1000 (0, n) elem)
val stuff = CharVector.tabulate (n, Seq.nth stuff)

(* ======================================================================
 * write to file and then read it back
 *)

val _ = WriteFile.dump (path, stuff)
val readback = ReadFile.contentsSeq path

(* ======================================================================
 * check correctness
 *)

val error =
  FindFirst.findFirst 1000 (0, n) (fn i => (
    (Seq.nth readback i <> elem i)
    handle Subscript => true
  ))

val correct =
  Seq.length readback = n andalso not (Option.isSome error)

val _ = print ("correct? " ^ (if correct then "yes" else "no") ^ "\n")

