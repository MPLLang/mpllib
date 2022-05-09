structure BinarySearch:
sig
  type 'a seq = 'a ArraySlice.slice
  val search: ('a * 'a -> order) -> 'a seq -> 'a -> int

  (* count the number of elements strictly less than the target *)
  val countLess: ('a * 'a -> order) -> 'a seq -> 'a -> int
end =
struct

  type 'a seq = 'a ArraySlice.slice

  fun search cmp s x =
    let
      fun loop lo hi =
        case hi - lo of
          0 => lo
        | n =>
          let
            val mid = lo + n div 2
            val pivot = ArraySlice.sub (s, mid)
          in
            case cmp (x, pivot) of
              LESS    => loop lo mid
            | EQUAL   => mid
            | GREATER => loop (mid+1) hi
          end
    in
      loop 0 (ArraySlice.length s)
    end


  fun countLess cmp s x =
    let
      fun loop lo hi =
        case hi - lo of
          0 => lo
        | n =>
          let
            val mid = lo + n div 2
            val pivot = ArraySlice.sub (s, mid)
          in
            case cmp (x, pivot) of
              GREATER => loop (mid+1) hi
            | _ => loop lo mid
          end
    in
      loop 0 (ArraySlice.length s)
    end

end
