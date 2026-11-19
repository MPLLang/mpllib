structure CLA = CommandLineArgs
val n = CLA.parseInt "size" 100000000
val target = CLA.parseInt "target" (n div 2) (* first true index; >= n means none *)
val grain = CLA.parseInt "grain" 1000
val calls = CLA.parseInt "calls" 1 (* number of sequential findFirst calls per run *)
val pred = CLA.parseString "pred" "suffix"
val impl = CLA.parseString "impl" "nondet"

val _ = print ("size " ^ Int.toString n ^ "\n")
val _ = print ("target " ^ Int.toString target ^ "\n")
val _ = print ("grain " ^ Int.toString grain ^ "\n")
val _ = print ("calls " ^ Int.toString calls ^ "\n")
val _ = print ("pred " ^ pred ^ "\n")
val _ = print ("impl " ^ impl ^ "\n")

(* pred "suffix": every index >= target satisfies the predicate.
 * pred "point":  only index target satisfies the predicate. *)
val flags: Word8.word Seq.t =
  case pred of
    "suffix" => Seq.tabulate (fn i => if i >= target then 0w1 else 0w0) n
  | "point" => Seq.tabulate (fn i => if i = target then 0w1 else 0w0) n
  | _ => Util.die ("unknown -pred " ^ pred ^ "; valid options are: suffix, point")

fun p i = Seq.nth flags i = 0w1

val finder =
  case impl of
    "findFirst" => FindFirst.findFirst grain
  | "nondet" => FindFirst.findFirstNondet grain
  | "serial" => FindFirst.findFirstSerial
  | _ =>
      Util.die
        ("unknown -impl " ^ impl ^ "; valid options are: findFirst, nondet, serial")

fun runAll () =
  let
    fun loop k acc =
      if k >= calls then acc
      else loop (k+1) (finder (0, n) p)
  in
    loop 0 NONE
  end

val result = Benchmark.run impl runAll

val expected = if target < n then SOME target else NONE
val _ =
  print ("result " ^ (case result of NONE => "NONE" | SOME i => Int.toString i) ^ "\n")
val _ =
  if result = expected then print "correct\n"
  else Util.die "INCORRECT RESULT"
