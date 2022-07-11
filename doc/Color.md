# structure Color

```sml
type color = {red: real, green: real, blue: real, alpha: real}
```

The color type, in RGBA format. Each of `red`, `green`, `blue`, and `alpha`
should be in the range `[0,1]`. The `alpha` value is for transparency:
opaque at `1.0`, and transparent at `0.0`.

```sml
(* hue in range [0,360)
 *   0-------60-------120-------180-------240-------300-------360
 *   red   yellow    green      cyan      blue      purple    red
 *
 * saturation in range [0,1]
 *    0--------------1
 *   grayscale   vibrant
 *
 * value in range [0,1]
 *    0--------------1
 *   dark           light
 *
 * alpha in range [0,1]
 *    0--------------1
 *   transparent    opaque
 *)
val hsva: {h: real, s: real, v: real, a: real} -> color
```

Convert from HSVA to the color type. Hue `h` should be in the range `[0,360)`.
Saturation `s`, value `v`, and alpha `a` should be in the range `[0,1]`.

```sml
val overlayColor: {fg: color, bg: color} -> color
```

Computes a new color by overlaying the (partially transparent)
foreground color `fg` on top of the background color `bg`. If the foreground
color is opaque, then the result is just the foreground color.

```sml
val colorToPixel: color -> pixel
```
Convert a color to a pixel. For transparency, the background is assumed to
be white. (If a different background is desired, use `overlayColor` and pick
an opaque background.)

```sml
val pixelToColor: pixel -> color
```
Convert a pixel to a color. The resulting color is opaque.

## Pixels

```sml
type channel = Word8.word
type pixel = {red: channel, green: channel, blue: channel}
```
Pixels stored in RGB format, with three color channels (each with 256 distinct
values).

```sml
(* hue in range [0,360)
 *   0-------60-------120-------180-------240-------300-------360
 *   red   yellow    green      cyan      blue      purple    red
 *
 * saturation in range [0,1]
 *    0--------------1
 *   grayscale   vibrant
 *
 * value in range [0,1]
 *    0--------------1
 *   dark           light
 *)
val hsv: {h: real, s: real, v: real} -> pixel
```
Convert from HSV format to the pixel type. Hue `h` should be in the range
`[0,360)`, and saturation `s` and value `v` should be in the range `[0,1]`.

```sml
val white: pixel
val black: pixel
val red: pixel
val blue: pixel
```
A few colors.

```sml
val distance: pixel * pixel -> real
val approxHumanPerceptionDistance: pixel * pixel -> real
```
Various distance metrics between colors.

The `distance` function computes
simple Euclidean distance, which is cheap to compute but does not accurately
characterize human perceived distance.

The `approxHumanPerceptionDistance` function computes a decent approximation
for the distance between colors, accounting for non-linearities in human
perception. This is based on the low-cost approximation described
[here](https://www.compuphase.com/cmetric.htm).
