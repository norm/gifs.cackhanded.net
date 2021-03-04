#!/bin/bash

@test generate_original {
    # FIXME
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run make_gif tests/config/original.toml $BATS_TMPDIR/gif
    echo "$output"

    [ "$status" -eq 0 ]
    [ "${lines[0]}" == "    640x480 dither=bayer_scale=4 fps=original" ]
    [ "${lines[1]}" == "    64 colours (64 initially)" ]
    [ "${lines[2]}" == "    size 1684875" ]
    [ "${lines[3]}" == "  < optimised with loss 0, now 1555222, 92.3% of original" ]
    diff -u $BATS_TMPDIR/gif tests/gifs/original.gif
}

@test generate_lossy {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run make_gif tests/config/lossy.toml $BATS_TMPDIR/gif
    echo "$output"

    [ "${lines[2]}" == "    size 1684875, max_size 1048576" ]
    [ "${lines[3]}" == "  < optimised with loss 20, now 1253148, 74.3% of original" ]
    [ "${lines[4]}" == "  < optimised with loss 30, now 1132900, 108.0% of max" ]
    [ "${lines[5]}" == "  < optimised with loss 40, now 1045286, 99.6% of max" ]

    [ "$status" -eq 0 ]
    diff -u $BATS_TMPDIR/gif tests/gifs/lossy.gif
}

@test generate_fps {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run make_gif tests/config/fps.toml $BATS_TMPDIR/gif
    echo "$output"

    [ "$status" -eq 0 ]
    [ "${lines[0]}" == "    640x480 dither=bayer_scale=4 fps=10" ]
    diff -u $BATS_TMPDIR/gif tests/gifs/fps.gif
}

@test generate_scale {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run make_gif tests/config/scale.toml $BATS_TMPDIR/gif
    echo "$output"

    [ "$status" -eq 0 ]
    [ "${lines[0]}" == "    480x360 dither=floyd_steinberg fps=10" ]
    diff -u $BATS_TMPDIR/gif tests/gifs/scale.gif
}

@test generate_crop {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run make_gif tests/config/crop.toml $BATS_TMPDIR/gif
    echo "$output"

    [ "$status" -eq 0 ]
    diff -u $BATS_TMPDIR/gif tests/gifs/crop.gif
}

@test generate_clips {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run make_gif tests/config/clips.toml $BATS_TMPDIR/gif
    echo "$output"

    [ "$status" -eq 0 ]
    diff -u $BATS_TMPDIR/gif tests/gifs/clips.gif
}

@test generate_captions {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run make_gif tests/config/captions.toml $BATS_TMPDIR/gif
    echo "$output"

    [ "${lines[1]}" == '  " font_size=24 placement=[169, 321] And the climb' ]
    [ "${lines[2]}" == '  " font_size=24 placement=[199, 321] is going' ]
    [ "${lines[3]}" == '  " font_size=24 placement=[82, 321] Where no man has gone before' ]
    [ "${lines[4]}" == "    102 colours (96 initially)" ]

    [ "$status" -eq 0 ]
    diff -u $BATS_TMPDIR/gif tests/gifs/captions.gif
}

@test generate_captions_noscale {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run make_gif tests/config/captions_noscale.toml $BATS_TMPDIR/gif
    echo "$output"

    [ "$status" -eq 0 ]
    diff -u $BATS_TMPDIR/gif tests/gifs/captions_noscale.gif
}

@test generate_clips_captions {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run make_gif tests/config/clips_captions.toml $BATS_TMPDIR/gif
    echo "$output"

    [ "$status" -eq 0 ]
    diff -u $BATS_TMPDIR/gif tests/gifs/clips_captions.gif
}

@test generate_clips_captions_timing {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run make_gif tests/config/clips_captions_timing.toml $BATS_TMPDIR/gif
    echo "$output"

    [ "$status" -eq 0 ]
    diff -u $BATS_TMPDIR/gif tests/gifs/clips_captions_timing.gif
}

@test generate_palette_additions {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run make_gif tests/config/captions_colours.toml $BATS_TMPDIR/gif
    echo "$output"

    [ "${lines[4]}" == "    58 colours (48 initially)" ]

    [ "$status" -eq 0 ]
    diff -u $BATS_TMPDIR/gif tests/gifs/captions_colours.gif
}
