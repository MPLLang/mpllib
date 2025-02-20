structure CLA = CommandLineArgs
val n = CLA.parseInt "size" 1000000
val keys = CLA.parseInt "keys" 100
val seed = CLA.parseInt "seed" 15210
val impl = CLA.parseString "impl" "merge"

val _ = print ("size " ^ Int.toString n ^ "\n")
val _ = print ("keys " ^ Int.toString keys ^ "\n")
val _ = print ("seed " ^ Int.toString seed ^ "\n")
val _ = print ("impl " ^ impl ^ "\n")

val input1 = Seq.tabulate (fn i => Util.hash (seed + i) mod keys) n
val () = Mergesort.sortInPlace Int.compare input1

val input2 = Seq.tabulate (fn i => Util.hash (seed + n + i) mod keys) n
val () = Mergesort.sortInPlace Int.compare input2

val merger =
  case impl of
    "merge" => Merge.merge
  | "stable-merge" => StableMerge.merge
  | "stable-merge-low-span" => StableMergeLowSpan.merge
  | "seqified-merge" => SeqifiedMerge.merge
  | _ =>
      Util.die
        ("unknown -impl " ^ impl
         ^
         "; valid options are: merge, stable-merge, stable-merge-low-span, seqified-merge")

val output = Benchmark.run impl (fn () => merger Int.compare (input1, input2))
val _ = print (Util.summarizeArraySlice 10 Int.toString output ^ "\n")
