gifs.cackhanded.net
===================

Source files for generating https://gifs.cackhanded.net

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

[palette]
add = [
    '#5a7e4c',
    '#d5dc4b',
]
show = 1

[output]
brighten = '0.05'
colours  = '192'
mode     = 'full'
max_size = '2mb'
dither   = 'floyd_steinberg'

[[clip]]
start = '2'
end   = '3'

[[clip]]
start = '6'
end   = '7'

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
* `end` is the [duration][dur] into the source video file where the GIF
  should end
* `crop` applies a [cropping value][crop] to the video before it is
  converted, and crucially before any resize happens so that the output
  width of the GIF is not reduced

You can either `end` or `duration`, not both.

[dur]: http://ffmpeg.org/ffmpeg-utils.html#time-duration-syntax
[crop]: http://ffmpeg.org/ffmpeg-filters.html#crop


### `[[clip]]` describes a clip taken from the source

Note the double square brackets to indicate `clip` is an entry in an array,
supporting multiple clips in a GIF. You can combine disconnected parts of
the source video into one GIF, eliminating the stuff in between. Each `clip`
needs two keys:

* `start` is the time in seconds from the start of the video
* `end` is the time in seconds from the start of the video

Combining these with `start` in the `[video]` section (see above) means
it is the time in seconds from that start point, not the very start of
the video source.


### `[output]` describes the GIF

* `brightness` is a number between -1 (completely dark) and 1 (completely
  light) that will dial up or down the brightness from the source video;
  default is 0 (unchanged)
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
* `loss` is the amount of artifacts allowed when initially optimising the
  GIF's size; default is `0`
* `max_size` is the maximum size in bytes of the GIF, if the output is
  larger than this value `gifsicle` will be run with increasing levels
  of `loss` to shrink the file size at the expense of image quality
  (can be expressed in megabytes, eg `1.5mb`)
* `dither` is how the palette colours are dithered to create the appearance
  of more colours:
    * `bayer:bayer_scale=1` — the scale is an integer between 0 and 5
    * `floyd_steinberg`
    * `sierra2`
    * `sierra2_4a`

  The default is `bayer:bayer_scale=4`. Illustrative samples can be found in
  "[High quality GIF with FFmpeg][quality]".

### `[palette]` provides finer grained control over the colour palette chosen

* `add` is an array of colours (in any format compatible with
  [the Pillow ImageColor][col] module) to add to the initial palette
  formed from the video source
* `show` will open the final palette selection for inspection

### `[[caption]]` describes the caption(s)

Note the double square brackets to indicate `caption` is an entry in an
array, supporting multiple captions in a GIF.

* `text` is the caption's text
* `font` is the font to use for the caption, expected to be found in the
  `fonts/` directory; the default is `assistant-semibold.ttf`
* `from` the [duration][dur] when the caption should start appearing in the GIF
* `to` the [duration][dur] when the caption should stop appearing
* `size` the largest size in pixels of the text, however it will always be
  sized down until the text fits across the GIF (`caption` reports the size 
  actually used); defaults to 40
* `margin` the margin around the caption text, to stop it butting against
  the edge of the GIF; defaults to 10
* `colour` the colour (in a format compatible with
  [the Pillow ImageColor][col] module) to use for the caption; default is
  white
* `stroke_colour` the colour to use for the stroke around around the caption;
  default is black
* `stroke_width` the width in pixels for the stroke, 0 to remove; default
  is 2
* `align` is how to align the text (only makes sense for multi-line strings),
  `left`, `center`, or `right`; defaults to `left`
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


### Note on colours

If you specifically add colours in `[palette]`, or use a caption, the output
GIF will probably use more colours than specified in the `[output]` section.
The colours of both the caption text and the outline stroke are interpolated,
and up to six colours per caption added to the GIF.

As an example, creating a GIF from a video source contains no black or white
elements and using a white caption with black outline, the palette used will
be restricted by default to 64 colours, but black, white, and four shades of
grey will be added, to a total of 70 colours. Using multiple captions of the
same colour will not increase the palette, but multiple captions of different
colours will.

If you have set the GIF colours to 256 and used captions, it is likely that
some of the colours calculated for the palette will be overwritten with
caption colours.


## Making GIFs

To install pre-requisites:

    # tools to make GIFs
    % brew install entr ffmpeg gifsicle youtube-dl

    # the python libraries to make captions
    % pip install -r requirements.txt

    # example Google Fonts from github.com/google/fonts to use in captions;
    # see the [Makefile](Makefile) for the command to get others
    make google-fonts

Some GIFs use fonts such as
[Acherus Grotesque](https://www.fontspring.com/fonts/horizon-type/acherus-grotesque) and
[Morl Rounded](https://www.fontspring.com/fonts/typesketchbook/morl) which
are not freely available.

To run the tests (currently only fully works on macOS, with the right video
and font file in place; see [workflow](.github/workflows/tests.yaml) for more
information):

    # honestly, don't bother unless you're changing the code
    % make test

To make the GIFs:

    # fetch youtube videos, issue reminders about other sources
    % ./script/get_videos

    # create GIFs
    % make

    # create GIFs with FFmpeg debugging output
    % GIF_DEBUG=y make

To add a new GIF:

    % ./script/new airplane/surely-you-cant-be-serious

    # (opens config in Sublime Text)
    # edit the config, save and close, and it makes the GIF
    # (opens the GIF in Safari for previewing)

    # this will rebuild the GIF and refresh it in Safari as
    # you continue tweaking the config until you are happy
    % make remake

    # when done, update the published date
    % ./script/now airplane/surely-you-cant-be-serious

    # commit and push (GitHub actions will update the website)
    % git add source/airplane/surely-you-cant-be-serious*
    % git commit -m'Add GIF'
    % git push origin main

