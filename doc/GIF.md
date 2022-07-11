# structure GIF

Support for `.gif` file format.

```sml
type pixel = Color.pixel
```

Colors are defined by the [`Color`](doc/Color.md) module.

```sml
type image = {height: int, width: int, data: pixel Seq.t}
```

An image is a [`Seq.t`](doc/Seq.md) where the pixel at `(i,j)` is stored
at index `i*width + j`. That is, `i` (where `0 <= i < height`) is the row
index, and `j` (where `0 <= j < width`) is the column index. The top-left of
the image is at `(0,0)`.

**Note**: this representation is identical to [`PPM.image`](doc/PPM.md), making
it easy to interface between the two structures.

```sml
val write: string -> image -> unit
```
`write path img` outputs the image `img` to a file at the path `path` (which
should have `.gif` file extension). The output image is compressed to 128
colors.

```sml
val writeMany:
  string             (* output path *)
  -> int             (* microsecond delay between images *)
  -> Palette.t       (* a color palette *)
  -> { width: int    (* images to output w/ colors defined by palette indices *)
     , height: int
     , numImages: int
     , getImage: int -> int Seq.t
     }
  -> unit
```
`writeMany path usDelay palette {width, height, numImages, getImage}` writes
a simple animation to the path `path` (which should have file extension `.gif`).
The animation is set to loop forever, and between each frame of the animation
is a delay of `usDelay` microseconds.

There are `numImages` frames in the animation, where the `n`th frame is defined
by `getImage(n)`. The result of `getImage` should be a sequence of color
palette indices, where the palette index of the pixel at `(i,j)` is given by
`Seq.nth (getImage(n)) (i*width + j)`.

See below for more info about color palettes. In particular, note that an
image can be compressed into a color palette using `#remap palette image`.

## structure GIF.Palette

```sml
type t = {colors: pixel Seq.t, remap: image -> int Seq.t}
```
The color palette type. The number of colors is `Seq.length colors`, and
the `i`th color is defined as `Seq.nth colors i`.

Color palettes come with a `remap` function to efficiently remap an entire
image.

```sml
val remapColor: t -> pixel -> int
```
`remapColor palette p` computes the palette index of the pixel `p`. (The
new color is `Seq.nth (#colors palette) i` where `i` is the result of
`remapColor`.)

```sml
val summarize: pixel list -> int -> image -> t
```
`summarize mandatoryColors numColors image` constructs a "well-space" color
palette by sampling from `image`. The first argument, `mandatoryColors`, is a
list of colors that must be included in the palette. The second argument,
`numColors`, is the desired number of colors in the output palette.

```sml
val summarizeBySampling: pixel list -> int -> (int -> pixel) -> t
```
Similar to `summarize`, except that rather than sampling from an image, we
instead use an arbitrary sampling function. In particular,
`summarizeBySampling mandatoryColors numColors sample` will compute a
"well-spaced" color palette from the colors
`{sample(0), sample(1), sample(2), ...}`. It will take as many samples as
necessary to produce a decent palette of size `numColors`.

```sml
val quantized: (int * int * int) -> t
```
Construct a simple uniformly quantized color palette by bucketing. The
arguments are `(rnb, gnb, bnb)` which are the number of buckets for each of
red, green, and blue, respectively.

**Requires**: `1 <= rnb,gnb,bnb <= 256` such that
`rnb * gnb * bnb <= 256`.

## structure GIF.LZW

This structure has various internal details about the `.gif` LZW compression
scheme. These are not documented, and are only exposed in the interface
for purposes of benchmarking.
