# structure PPM

Support for the simple `.ppm` image file format.

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

**Note**: this representation is identical to [`GIF.image`](doc/GIF.md), making
it easy to interface between the two structures.

```sml
val elem: image -> (int * int) -> pixel
```
Look up the pixel at indices `(i,j)`.

```sml
val read: string -> image
```
Open a `.ppm` file at the given path and parse an image from it. Currently
supports `P3` and `P6` formats.

```sml
val write: string -> image -> unit
```
`write path img` outputs the image `img` to a file at the path `path` (which
should have `.ppm` file extension). The output file is in `P6` format.


## Subimages

```sml
type box = {topleft: int * int, botright: int * int}
```
A box-shaped region within an image is defined by its top-left and bottom-right
coordinates. For a box `{topleft=(i1,j1), botright=(i2,j2)}`, the height of
the box is `i2-i1` and the width is `j2-j1`.

```sml
val subimage: box -> image -> image
```
Extract a box-shaped region of an image.

```sml
val replace: box -> image -> image -> image
```
`replace box image subimage` replaces the region `box` of `image` with
`subimage`, returning a new image. The dimensions of `subimage` must be at
least as big as `box`.
