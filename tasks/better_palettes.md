ffmpeg's `palettegen` filter only has the control `stats_mode` for choosing
colours, either `full` all frames as one palette or `diff` giving more weight
to frame differences (better for animation). Other than that, there is no
control over the colour choices.

Investigate `libimagequant` to see if it produces better palettes.

- [ ] test palette quality against ffmpeg:

Find a GIF that's had to force colours in the palette because ffmpeg didn't
pick them. Try it with imagequant.

- [ ] test reducing the colour amount:

If imagequant does well, can we reduce the number of colours and still
achieve good results? Does this decrease image size, or is there a size
increase due to dithering, offseting any possible savings?

------

If it works out, replace ffmpeg's palette chooser.

- [ ] extract the video segment and produce a tiled composite (a strip
      or a grid?) using transparent background
- [ ] use the composite to calculate a palette, mixing in the caption and
      fixed colours (replaces need for edit-palette)
- [ ] profile for speed

If not,

- [ ] add tests for the two different stats_mode settings, if we don't
      replace it entirely
