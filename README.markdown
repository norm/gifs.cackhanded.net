gifs.cackhanded.net
===================

Source files for generating https://gifs.cackhanded.net.
There is a rough [publishing schedule](schedule.markdown)
for future content.
No guarantees, substitutions, exchanges, or refunds.
Follow [@mnfpublishing][bot] for notifications
or subscribe to [an Atom feed][atom].

[bot]: https://twitter.com/mnfpublishing
[atom]: https://gifs.cackhanded.net/feeds


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
list = 1
show = 1

[output]
brightness = '0.05'
colours    = '192'
denoise    = true
mode       = 'full'
max_size   = '2mb'  # or 'auto'
dither     = 'floyd_steinberg'
stabilise  = 'static'

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
* `denoise` should be set to `true` to apply the `hqdn3d` filter (very
  useful for older, grainy footage, smoother video makes for smaller GIFs)
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
  GIF's size; default is `0`. Set to `no` to disable optimising.
* `max_size` is the maximum size in bytes of the GIF, if the output is
  larger than this value `gifsicle` will be run with increasing levels
  of `loss` to shrink the file size at the expense of image quality
  (can be expressed in megabytes, eg `1.5mb`, or as `auto` to calculate
  a maximum based on `0.45mb` per second from the length of the GIF).
  If `loss` is set to `no`, `max_size` is ignored.
* `slowdown` is a multiplier to make the output GIF animate slower than the
  source video (slo-mo). A multiplier lower than 1 will speed it up.
* `dither` is how the palette colours are dithered to create the appearance
  of more colours:
    * `bayer:bayer_scale=1` — the scale is an integer between 0 and 5
    * `floyd_steinberg`
    * `sierra2`
    * `sierra2_4a`
* `stabilise` attempts to stabilise (deshake) the output GIF, the value is the
  number of frames before/after the current frame to consider for
  stabilisation, or the value `static` which tries to emulate a static camera
  (note that this will crop the video somewhat)

  The default is `bayer:bayer_scale=4`. Illustrative samples can be found in
  "[High quality GIF with FFmpeg][quality]".

### `[palette]` provides finer grained control over the colour palette chosen

* `add` is an array of colours (in any format compatible with
  [the Pillow ImageColor][col] module) to add to the initial palette
  formed from the video source
* `list` will list the RGB values for each colour used in the final palette
* `show` will open the final palette PNG for inspection

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
* `anchor` is the [alignment of the text][an] relative to the `placement`;
  default is `la`
* `type` is the caption type set to use, described below

[col]: https://pillow.readthedocs.io/en/stable/reference/ImageColor.html
[an]: https://pillow.readthedocs.io/en/stable/handbook/text-anchors.html

#### Caption type sets

Rather than multiple GIF configuration files all having identical settings for
font, size, margin…, type sets can be used. Caption type sets are defined in
the `_site.toml`:

    [type_set.zim_shout]
    align     = 'center'
    font      = 'anteb-extrablack.otf'
    margin    = '20'
    placement = 'bc'
    size      = '48'

Then a caption only needs to declare the type to have all of the type set
values applied. Note, any values in the source TOML take precedence, acting
as overrides to the type set.

    [[caption]]
    type      = 'zim_shout'
    placement = 'br'

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

To add a new GIF, use the `new` script:

    % ./script/new airplane/surely-you-cant-be-serious

It will create a new configuration from either a context-specific template (in
this example, it would look for `source/airplane/new`), or the default
template (stored in `source/new`), and open it in Sublime Text.

Once it has been edited for rough timings, captions, etc. closing the file
makes the GIF and opens it in Safari for previewing. The file is reopened
in Sublime Text and a loop now commences; as changes are saved to the file
the GIF will be automatically remade. During this loop, pressing:

  * **G** will run `make gifwrapped` — to send any new GIFs to the
    right location in Dropbox for [GIFwrapped][gw] to pick them up
    for on-device previewing
  * **I** will show (in Sublime Text) a bunch of info about the built GIF
  * **L** will mark the output with a line — useful when comparing runs
    with different settings for output sizes, for example
  * **P** will open the GIF in Preview — to be able to step through it
    frame by frame, useful for getting caption/cut timings right
  * **Return** will output a blank line
  * **^L** will clear the screen
  * **?** will output a reminder of the keys available
  * **Q** will quit the loop and exit

To add the GIF to the site for right now, update the published date and
push it to GitHub:

    % ./script/now airplane/surely-you-cant-be-serious
    % git add source/airplane/surely-you-cant-be-serious*
    % git commit -m'Add GIF'
    % git push origin main

Otherwise, schedule it for the future and commit at your leisure.

[gw]: https://gifwrapped.co


## Scheduling GIFs

To schedule a post on a given day without the need for human interaction, set
the `published` date to 7am UTC on a given future day.

The site configuration is set to ignore GIFs with a `published` date in the
future. A GitHub [workflow](.github/workflows/rebuild.yaml) is set to rebuild
the site daily, and runs after 7am (so there will be a short delay between 
7am and the content appearing on the site, I'm not bothered).


## Rescheduling GIFs

To reschedule some subset of GIFs for a new date (most typically to push
publishing by days/weeks as something new is inserted into the schedule),
use the `push` script:

    # push anything in wargames/ by one week
    ./script/push wargames '1 week'

This will only affect the schedule for future GIFs, anything already
published will be left alone.


## Listing the scheduled GIFs

To list what is scheduled, there is a `next` script in the repo.

    # find the next day with no morning GIF scheduled
    # (afternoon GIFs are considered secondary content);
    # also shows a count and breakdown of what is unscheduled
    ./script/next

    # list the next day with no morning GIF scheduled, the first day that
    # would have no scheduled GIF if any as-yet unscheduled GIFs were used
    # to fill in the gaps, and a count and breakdown of what is unscheduled
    ./script/next filling

    # show what is scheduled in the next 60 days
    ./script/next 60

    # show what is scheduled in the next 90 days, 
    # visually highlighting the start of the week
    ./script/next 90 high

    # show what is scheduled on Wednesdays in the next 30 days (30 is default)
    ./script/next wed

    # coming on weekends in the next year
    ./script/next 365 sat sun

    # show what is scheduled in the morning for the next 30 days
    ./script/next am

    # show what is scheduled in the afternoon on weekends for the next 90 days
    ./script/next 90 sat sun pm

    # show only days with no scheduled content in the next 90 days
    ./script/next 90 empty

    # show only days with scheduled content in the next 90 days
    ./script/next 90 full
