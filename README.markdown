gifs.cackhanded.net
===================

Source files for generating http://gifs.cackhanded.net

The GIFs are made using ffmpeg, following advide from the GIPHY engineering
blog post "[How to make GIFs with FFMPEG][how]",

[how]: https://engineering.giphy.com/how-to-make-gifs-with-ffmpeg/

The output quality is improved with a global palette and dithering, using
tips from "[High quality GIF with FFmpeg][quality]".

[quality]: http://blog.pkh.me/p/21-high-quality-gif-with-ffmpeg.html

Captions are added using transparent PNGs overlaid on the image,
which are created on the fly by the [`caption`](bin/caption) script
in this repository.

The file size is then reduced using
[gifsicle](https://www.lcdf.org/gifsicle/).

## Specifying a GIF using TOML

Each GIF is described in TOML:

```toml
[video]
source   = 'file'
file     = 'lilo-and-stitch'
ext      = 'm4v'
start    = '1:24'
duration = '4.8'
crop     = '628:468'

[output]
colours  = 192
mode     = 'full'
max_size = 2048000
dither   = 'floyd_steinberg'

[[caption]]
text = 'What is that monstrosity?'
font = 'acherusgrotesque-black.otf'
from = '0'
to   = '2'

[[caption]]
text = 'Monstrosity?!'
from = '3'
to   = '10'
size = '100'

```

### `[video]` describes the source

* `source` key has one of two values, `file` or `youtube`
* `file` should be the filename without extension, 
  as found in the `videos/` directory
* `ext` should be the video file's extension
* `start` is the [duration][dur] into the source video file where the
  GIF will begin
* `duration` is how long the GIF should be
* `crop` applies a [cropping value][crop] to the video before it is
  converted, and crucially before any resize happens so that the output
  width of the GIF is not reduced

[dur]: http://ffmpeg.org/ffmpeg-utils.html#time-duration-syntax
[crop]: http://ffmpeg.org/ffmpeg-filters.html#crop


### `[output]` describes the GIF

* `colours` is the maximum number of colours to be used in the GIF,
  a lower number means a smaller GIF up to a point; default is 64,
  maximum is 256
* `mode` is used when creating the palette; default is `diff`:
    * `full` optimise colours for the full image
    * `diff` optimise colours for the differences between frames
    * `single` don't optimise
  The differences are illustrated in more detail in
  "[High quality GIF with FFmpeg][quality]")
* `width` is how wide to make the GIF in pixels; default is 480,
  `original` leaves it the same as the source
* `fps` is how many frames per second to include in the GIF, a lower
  number means a smaller GIF but less smooth movement; default
  is 10 (animation-like), `original` leaves it the same as the source
* `max_size` is the maximum size in bytes of the GIF, if the output is
  larger than this value `gifsicle` will be run with increasing levels
  of `--lossy` to shrink the file size at the expense of image quality
* `dither` is how the palette colours are dithered to create the appearance
  of more colours:
    * `bayer:bayer_scale=1` — the scale is an integer between 0 and 5
    * `floyd_steinberg`
    * `sierra2`
    * `sierra2_4a`

  The default is `bayer:bayer_scale=4`. Illustrative samples can be found in
  "[High quality GIF with FFmpeg][quality]".


### `[[caption]]` describes the caption(s)

Note the double square brackets to indicate `caption` is an entry in an
array, supporting multiple captions in a GIF.

* `text` is the caption's text
* `font` is the font to use for the caption, expected to be found in the
  `fonts/` directory; the default is `morlrounded-regular.otf`
* `from` the [duration][dur] when the caption should start appearing in the GIF
* `to` the [duration][dur] when the caption should stop appearing
* `size` the largest size in pixels of the text, however it will always be
  sized down until the text fits across the GIF (`caption` reports the size 
  actually used); defaults to 128
* `margin` the margin around the caption text, to stop it butting against
  the edge of the GIF; defaults to 10
* `colour` the colour (in a format compatible with
  [the Pillow ImageColor][col] module) to use for the caption; default is
  white
* `stroke_colour` the colour to use for the stroke around around the caption;
  default is black
* `stroke_width` the width in pixels for the stroke, 0 to remove; default
  is 1
* `placement` a string representing where the caption should appear;
  default is `bl`, acceptable values are:
  * `50,100` — 50 pixels across from the left, 100 pixels down from the top
  * `-50,-100` — 50 pixels across from the right, 100 pixels up from the
    bottom
  * `t` — at the **t**op, `margin` pixels down from the top
  * `m` — in the **m**iddle, centered vertically
  * `b` — at the **b**ottom, `margin` pixels up from the bottom
  * `l` — at the **l**eft, `margin` pixels across from the left
  * `c` — in the **c**enter, centered horizontally
  * `r` — at the **r**ight, `margin` pixels across from the right
  * `c,-60` — letters and numbers can be used in combination, and if
    only letters the comma can be omitted
  `caption` reports the x,y position actually used

[col]: https://pillow.readthedocs.io/en/stable/reference/ImageColor.html


## Making GIFs

To install pre-requisites:

    % brew install ffmpeg gifsicle youtube-dl
    % pip install -r requirements.txt

To make the GIFs:

    # fetch youtube videos, issue reminders about other sources
    % ./script/get_videos

    # create GIFs
    % make
