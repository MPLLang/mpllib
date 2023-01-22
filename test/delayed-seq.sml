functor Ex(S: SEQUENCE) =
struct
  fun sumNonNegative (s: int Seq.t) =
    S.reduce op+ 0
      (S.map (fn x => Int.max (0, x))
        (S.fromArraySeq s))

  fun evenMultiplesUpto (n: int) (s: int Seq.t) =
    let
      fun multiples x =
        let
          val numMultiples = n div x - 1
        in
          S.tabulate (fn i => (i+2)*x) numMultiples
        end
    in
      S.toArraySeq (S.filter (fn x => x mod 2 = 0)
        (S.flatten (S.map multiples (S.fromArraySeq s))))
    end
end

structure CLA = CommandLineArgs

functor Tester(
  structure S: SEQUENCE
  val sName: string
) =
struct
  structure ExS = Ex(S)
  structure ExRef = Ex(Seq)

  val n = CLA.parseInt "n" 1000000
  val numTests = CLA.parseInt "num-tests" 10

  fun testSumNonNegative seed =
    let
      val seed = Util.hash seed
      val input =
        Seq.tabulate (fn i => 9000 - (Util.hash (seed+i) mod 10000)) n
      val r = ExS.sumNonNegative input
      val rRef = ExRef.sumNonNegative input
    in
      if r = rRef then "test passed" else
        ("ERROR: " ^ sName ^ ": testSumNonNegative")
    end

  fun testEvenMultiplesUpto seed =
    let
      val seed = Util.hash seed
      val m = 1000 + (Util.hash seed mod 10000)
      val input = Seq.tabulate (fn i => 3 + (Util.hash (seed+i+1) mod 100)) (n div 10)

      val r = ExS.evenMultiplesUpto m input
      val rRef = ExRef.evenMultiplesUpto m input
    in
      if Seq.equal op= (r, rRef) then "test passed" else
        ("ERROR: " ^ sName ^ ": testEvenMultiplesUpto")
    end

  val numTests1 = numTests div 2
  val numTests2 = numTests - numTests1

  fun msg testNum s =
    print ("[" ^ Int.toString (testNum+1) ^ "/" ^ Int.toString numTests ^ "]: " ^ s ^ "\n")

  fun doTests () =
    ( Util.for (0, numTests1) (fn testNum => msg testNum (testSumNonNegative testNum))
    ; Util.for (numTests1, numTests) (fn testNum => msg testNum (testEvenMultiplesUpto testNum))
    )
end

structure TestDS = Tester(structure S = DelayedSeq val sName = "DelayedSeq")
structure TestODS = Tester(structure S = OldDelayedSeq val sName = "OldDelayedSeq")

structure Main =
struct
  val impl = CLA.parseString "impl" "new"

  val _ =
    case impl of
      "old" => TestODS.doTests ()
    | _ => TestDS.doTests ()
end
