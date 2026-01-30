# Rapid drafting

Create a tool `carve` to pull out draft GIFs more quickly. Run
against the video source, it should allow entry of timecodes or
searching against the dialogue in the subtitles to create rough
draft GIFs which can then be refined.

This will replace `script/new`.

- [ ] if there is an embedded SRT, extract it
- [ ] create (prompting as needed) the index.markdown for the movie, series,
      episode, etc.
- [ ] quick entry of start timecode plus duration, understanding 1:15:35,
      3:04.5, 6s
- [ ] fuzzy search to find a word or phrase in the subtitles, present nearby
      context lines to select a range
- [ ] allow content specific templates to override the default


# Refinement

Create a tool `polish` to iteratively rebuild GIFs as the TOML is tweaked.
An improvement on the core loop in `script/new`.

- [ ] search for `draft = true`, exiting when no remaining GIFs are in draft
- [ ] key to skip temporarily
- [ ] key to finalise, removing draft, and running checks against the TOML
- [ ] improve the screen handling to have zones, keeping the keys in view
      when clearing the screen


Add some tools to `make_gif` to help when refining draft GIFs.
In the TOML, include:

```toml
[debug]
grid = true
sizes = true
timecode = true
```

- [ ] add an overlay of a quartered grid to help visualise spacing
- [ ] annotate the grid with pixel measurements to help when cropping
- [ ] issue a warning if the requested crop is out of bounds
- [ ] provide a timecode to help with cut and caption timing

Cropping is specified `crop = '3240:1820:400:128'` to simplify passing it
to ffmpeg. A more human-readable and self-documenting version would be:

```toml
[video.crop]
top = 128
left = 400
width = 3240
height = 1820
```

- [ ] expand crop to use multiple keys, not one string
