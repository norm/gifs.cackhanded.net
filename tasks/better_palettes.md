ffmpeg's `palettegen` filter only has the control `stats_mode` for choosing
colours, either `full` all frames as one palette or `diff` giving more weight
to frame differences (better for animation). Other than that, there is no
control over the colour choices.

Investigate `libimagequant` to see if it produces better palettes.

- [x] test palette quality against ffmpeg:

Find a GIF that's had to force colours in the palette because ffmpeg didn't
pick them. Try it with imagequant.

- [x] test reducing the colour amount:

If imagequant does well, can we reduce the number of colours and still
achieve good results? Does this decrease image size, or is there a size
increase due to dithering, offseting any possible savings?

**Findings:**

Tested with WarGames "global thermonuclear war" GIF which is using 66
hand-picked colours because ffmpeg auto palette didn't choose good skin tones,
going with an overabundance of blue from the screen.

Trying imagequant with 48 colours produces comparable results to the previous
66 forced colours. Skin tones are better represented without manual
intervention, though not perfect.

The composite approach (tiling all frames) works but has pixel-count bias:
frames with more screen time dominate. Weighting frames (duplicating minority
content like face frames) can further improve results:

| Composite ratio   | Blues | Skin tones |
|-------------------|-------|------------|
| 83 blue : 23 face | 30    | 7          |
| 1 blue : 1 face   | 25    | 10         |
| 1 blue : 4 face   | 21    | 13         |

Even then, the red of David's lips was never chosen, just a greater variety of
skin tones and background colours. So manual intervention remains necessary,
but the improvement in colour choice is there, and a simple forced weighting
of some frames could push the results further towards the desired palette
without manual sampling of individual colours.

The ffmpeg palettegen runs in a few tens of seconds, but producing a
composite image takes seconds, as does imagequant choosing a palette from
the composite -- a 10x slowdown, so caching will be important.

- [X] extract the original segment, to a predictable filename
- [X] create a tiled image from the segment, to a predictable filename
- [ ] script to choose colours from the tiled image, accepting individual colours
      to add, ranges to add, and frames to duplicate (weighting)
- [ ] integrate into make_gif
