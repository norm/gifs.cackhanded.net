#!/bin/bash

green=$'\e'[32m
cyan=$'\e'[36m
magenta=$'\e'[35m
reset=$'\e'[0m

@test generate_original {
    # FIXME
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run make_gif tests/config/original.toml $BATS_TMPDIR/output.gif
    echo "$output"

    [ "$status" -eq 0 ]
    [ "${lines[0]}" == "    640x480 dither=bayer_scale=4 fps=original" ]
    [ "${lines[1]}" == "    64 colours (64 initially)" ]
    [ "${lines[2]}" == "    size 1.62mb (duration 1.01) $magenta[auto max 0.45mb]$reset" ]
    [ "${lines[3]}" == "  $cyan< optimised with loss 0, now 1.49mb, 92.2% of original$reset" ]
    [ "${lines[4]}" == "  > 30 frames" ]
    # cp $BATS_TMPDIR/output.gif tests/gifs/original.gif
    diff -u $BATS_TMPDIR/output.gif tests/gifs/original.gif
}

@test generate_lossy {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run make_gif tests/config/lossy.toml $BATS_TMPDIR/output.gif
    echo "$output"

    [ "${lines[2]}" == "    size 1.62mb (duration 1.01), ${magenta}max_size 1.00mb$reset $magenta[auto max 0.45mb]$reset" ]
    [ "${lines[3]}" == "  $magenta< optimised with loss 20, now 1.20mb, 74.2% of original$reset" ]
    [ "${lines[4]}" == "  $magenta< optimised with loss 30, now 1.08mb, 108.3% of max$reset" ]
    [ "${lines[5]}" == "  $magenta< optimised with loss 40, now 1.00mb, 100.0% of max$reset" ]
    [ "${lines[6]}" == "  $green< optimised with loss 50, now 0.95mb, 94.6% of max$reset" ]

    [ "$status" -eq 0 ]
    # cp $BATS_TMPDIR/output.gif tests/gifs/lossy.gif
    diff -u $BATS_TMPDIR/output.gif tests/gifs/lossy.gif
}

@test generate_fps {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run make_gif tests/config/fps.toml $BATS_TMPDIR/output.gif
    echo "$output"

    [ "$status" -eq 0 ]
    [ "${lines[0]}" == "    640x480 dither=bayer_scale=4 fps=10" ]
    # cp $BATS_TMPDIR/output.gif tests/gifs/fps.gif
    diff -u $BATS_TMPDIR/output.gif tests/gifs/fps.gif
}

@test generate_scale {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run make_gif tests/config/scale.toml $BATS_TMPDIR/output.gif
    echo "$output"

    [ "$status" -eq 0 ]
    [ "${lines[0]}" == "    480x360 dither=floyd_steinberg fps=10" ]
    # cp $BATS_TMPDIR/output.gif tests/gifs/scale.gif
    diff -u $BATS_TMPDIR/output.gif tests/gifs/scale.gif
}

@test generate_crop {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run make_gif tests/config/crop.toml $BATS_TMPDIR/output.gif
    echo "$output"

    [ "$status" -eq 0 ]
    # cp $BATS_TMPDIR/output.gif tests/gifs/crop.gif
    diff -u $BATS_TMPDIR/output.gif tests/gifs/crop.gif
}

@test generate_slowdown {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run make_gif tests/config/slowdown.toml $BATS_TMPDIR/output.gif
    echo "$output"

    [ "$status" -eq 0 ]
    # cp $BATS_TMPDIR/output.gif tests/gifs/slowdown.gif
    diff -u $BATS_TMPDIR/output.gif tests/gifs/slowdown.gif
}

@test generate_clips {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run make_gif tests/config/clips.toml $BATS_TMPDIR/output.gif
    echo "$output"

    [ "$status" -eq 0 ]
    # cp $BATS_TMPDIR/output.gif tests/gifs/clips.gif
    diff -u $BATS_TMPDIR/output.gif tests/gifs/clips.gif
}

@test generate_captions {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run make_gif tests/config/captions.toml $BATS_TMPDIR/output.gif
    echo "$output"

    [ "${lines[1]}" == '  " font_size=40 placement=[121, 305] And the climb' ]
    [ "${lines[2]}" == '  " font_size=40 placement=[173, 305] is going' ]
    [ "${lines[3]}" == "  \" ${magenta}font_size=34${reset} placement=[16, 311] Where no man has gone before" ]
    [ "${lines[4]}" == "    102 colours (96 initially)" ]

    [ "$status" -eq 0 ]
    # cp $BATS_TMPDIR/output.gif tests/gifs/captions.gif
    diff -u $BATS_TMPDIR/output.gif tests/gifs/captions.gif
}

@test generate_captions_type_set {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    GIF_TYPE_SETS=tests/config/type_sets.toml \
        run make_gif tests/config/captions_type.toml $BATS_TMPDIR/output.gif
    echo "$output"

    [ "${lines[1]}" == '  " font_size=40 placement=[121, 305] And the climb' ]
    [ "${lines[2]}" == '  " font_size=100 placement=[75, 243] is going' ]
    [ "${lines[3]}" == "  \" ${magenta}font_size=32${reset} placement=[19, 313] Where no man has gone before" ]
    [ "${lines[4]}" == "    102 colours (96 initially)" ]

    [ "$status" -eq 0 ]
    # cp $BATS_TMPDIR/output.gif tests/gifs/captions_type.gif
    diff -u $BATS_TMPDIR/output.gif tests/gifs/captions_type.gif
}

@test generate_captions_noscale {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run make_gif tests/config/captions_noscale.toml $BATS_TMPDIR/output.gif
    echo "$output"

    [ "$status" -eq 0 ]
    # cp $BATS_TMPDIR/output.gif tests/gifs/captions_noscale.gif
    diff -u $BATS_TMPDIR/output.gif tests/gifs/captions_noscale.gif
}

@test generate_clips_captions {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run make_gif tests/config/clips_captions.toml $BATS_TMPDIR/output.gif
    echo "$output"

    [ "$status" -eq 0 ]
    # cp $BATS_TMPDIR/output.gif tests/gifs/clips_captions.gif
    diff -u $BATS_TMPDIR/output.gif tests/gifs/clips_captions.gif
}

@test generate_palette_additions {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run make_gif tests/config/captions_colours.toml $BATS_TMPDIR/output.gif
    echo "$output"

    [ "${lines[4]}" == "    58 colours (48 initially)" ]

    [ "$status" -eq 0 ]
    # cp $BATS_TMPDIR/output.gif tests/gifs/captions_colours.gif
    diff -u $BATS_TMPDIR/output.gif tests/gifs/captions_colours.gif
}
