structure Word16 :> WORD =
struct
  type word = Word32.word
  val wordSize = 16

  val mask: word = Word32.<< (0w1, 0w16) - 0w1

  fun nyi name =
    raise Fail
      ("mpllib: custom SML/NJ Word16 compatibility: not yet implemented: "
       ^ name)

  fun toLarge w = Word32.toLarge w
  val toLargeWord = toLarge

  fun toLargeX _ = nyi "toLargeX"
  fun toLargeWordX _ = nyi "toLargeWordX"

  fun fromLarge w =
    Word32.andb (mask, Word32.fromLarge w)

  val fromLargeWord = fromLarge

  fun toLargeInt w = Word32.toLargeInt w

  fun toInt w = Word32.toInt w

  fun toIntX w =
    if w >= Word32.<< (0w1, 0w15) then Word32.toIntX (w - Word32.<< (0w1, 0w16))
    else Word32.toIntX w

  fun fromInt i =
    let
      val _ =
        case Int.precision of
          NONE => ()
        | SOME p =>
            if p < wordSize then nyi "fromInt: Int.precision < wordSize" else ()
    in
      Word32.andb (mask, Word32.fromInt i)
    end

  fun toLargeIntX _ = nyi "toLargeIntX"
  fun fromLargeInt _ = nyi "fromLargeInt"

  fun andb (w1, w2) = Word32.andb (w1, w2)
  fun orb (w1, w2) = Word32.orb (w1, w2)
  fun xorb (w1, w2) = Word32.xorb (w1, w2)
  fun notb w = Word32.andb (mask, Word32.notb w)
  fun << _ = nyi "<<"
  fun >> _ = nyi ">>"
  fun ~>> _ = nyi "~>>"

  fun op+ (w1, w2) = Word32.andb (mask, w1 + w2)
  fun op- _ = nyi "-"
  fun op* _ = nyi "*"
  fun op div _ = nyi "div"
  fun op mod _ = nyi "mod"

  fun compare (w1, w2) = Word32.compare (w1, w2)
  fun op< (w1, w2) = Word32.< (w1, w2)
  fun op<= (w1, w2) = Word32.<= (w1, w2)
  fun op> (w1, w2) = Word32.> (w1, w2)
  fun op>= (w1, w2) = Word32.>= (w1, w2)

  fun ~ _ = nyi "~"
  fun min (w1, w2) = Word32.min (w1, w2)
  fun max (w1, w2) = Word32.max (w1, w2)

  fun fmt _ = nyi "fmt"
  fun toString w = Word32.toString w
  fun scan _ = nyi "scan"

  fun fromString s =
    case Word32.fromString s of
      NONE => NONE
    | SOME w => if w > mask then raise Overflow else SOME w

  fun popCount _ = nyi "popCount" (* ?? *)

end
