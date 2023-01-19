structure CLA = CommandLineArgs
val bucketSizeMin = CLA.parseInt "bucket-min" 10
val bucketSizeMax = CLA.parseInt "bucket-max" 1000
val numBuckets = CLA.parseInt "buckets" 1000
val seed = CLA.parseInt "seed" 15210
val numTests = CLA.parseInt "num-tests" 10

structure Key =
struct
  type key = int
  type t = key

  val compare = Int.compare

  fun comparePriority (k1, k2) =
    Word64.compare
      (Util.hash64_2 (Word64.fromInt k1),
       Util.hash64_2 (Word64.fromInt k2))

  val toString = Int.toString
end


structure A =
struct
  type 'a t = 'a Seq.t
  type 'a array = 'a Seq.t
  fun tabulate (n, f) = Seq.tabulate f n
  fun sub (s, i) = Seq.nth s i
  fun subseq s {start, len} = Seq.subseq s (start, len)
  fun update (s, i, x) =
    Seq.tabulate
      (fn j => if j = i then x else Seq.nth s j)
      (Seq.length s)
  fun length s = Seq.length s
end


structure CT =
  ChunkedTreap(
    structure Key = Key
    structure A = A
    val leafSize = 10
  )


fun check t i =
  case CT.lookup t i of
    NONE => false
  | SOME j => j = Util.hash i


fun hashTree (lo, hi) =
  let
    val t =
      SeqBasis.reduce 100 CT.join (CT.empty ()) (lo, hi) (fn i =>
        CT.singleton (i, Util.hash i)
      )
    val okay =
      SeqBasis.reduce 100 (fn (a,b) => a andalso b) true (lo, hi) (fn i =>
        check t i
      )
  in
    if okay then t
    else raise Fail "hashTree.check"
  end


fun hashInRange (lo, hi) seed =
  lo + (Util.hash seed) mod (hi-lo)


fun msg testNum s =
    print ("[" ^ Int.toString (testNum+1) ^ "/" ^ Int.toString numTests ^ "]: " ^ s ^ "\n")


fun test testNum seed =
  let
    val (sizes, seed) =
      ( Seq.tabulate (fn i => hashInRange (bucketSizeMin, bucketSizeMax+1) (seed+i)) numBuckets
      , seed+numBuckets
      )

    val (offsets, total) = Seq.scan op+ 0 sizes
    fun start i = Seq.nth offsets i
    fun stop i = if i+1 < numBuckets then Seq.nth offsets (i+1) else total


    val t =
      SeqBasis.reduce 100 CT.join (CT.empty ()) (0, numBuckets) (fn b =>
        hashTree (start b, stop b)
      )

    val okay =
      SeqBasis.reduce 100 (fn (a, b) => a andalso b) true (0, total) (fn i =>
        check t i
      )

  in
    if okay then
      msg testNum ("test passed (" ^ Int.toString total ^ " keys)")
    else
      raise Fail "check"
  end
  handle e => msg testNum (exnMessage e)


val _ =
  Util.for (0, numTests) (fn testNum => test testNum (seed + testNum*numBuckets))
