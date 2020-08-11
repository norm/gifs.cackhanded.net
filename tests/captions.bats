#!/bin/bash

@test caption_without_args_is_error {
    # FIXME 
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run ./bin/caption
    echo "$output"

    [ "$status" -eq 2 ]
}

@test basic_caption {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run ./bin/caption 480 300 'I am a caption' $BATS_TMPDIR/caption.png
    echo "$output"

    [ "$status" -eq 0 ]
    diff tests/output/caption.png $BATS_TMPDIR/caption.png
}

@test basic_caption_centred {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run ./bin/caption \
        480 300 \
        'I am a caption' \
        --placement 'mc' \
        $BATS_TMPDIR/caption.png
    echo "$output"

    [ "$status" -eq 0 ]
    diff tests/output/caption_centred.png $BATS_TMPDIR/caption.png
}

@test basic_caption_placement_negative {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run ./bin/caption \
        480 300 \
        'I am a caption' \
        --placement='-40,-40' \
        $BATS_TMPDIR/caption.png
    echo "$output"

    [ "$status" -eq 0 ]
    diff tests/output/caption_placement.png $BATS_TMPDIR/caption.png
}

@test basic_caption_colours {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run ./bin/caption \
        480 300 \
        'I am a caption' \
        --colour yellow \
        --stroke-colour red \
        --stroke-width 10 \
        $BATS_TMPDIR/caption.png
    echo "$output"

    [ "$status" -eq 0 ]
    diff tests/output/caption_colours.png $BATS_TMPDIR/caption.png
}

@test basic_caption_sizes {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run ./bin/caption \
        480 300 \
        'I am a caption' \
        --margin 50 \
        --font-size 100 \
        $BATS_TMPDIR/caption.png
    echo "$output"

    [ "$status" -eq 0 ]
    diff tests/output/caption_sizes.png $BATS_TMPDIR/caption.png
}

@test basic_caption_font {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run ./bin/caption \
        480 300 \
        'I am a caption' \
        --font 'assistant-bold.ttf' \
        --font-size 100 \
        $BATS_TMPDIR/caption.png
    echo "$output"

    [ "$status" -eq 0 ]
    diff tests/output/caption_assistant_bold.png $BATS_TMPDIR/caption.png
}

@test basic_caption_newline_align {
    [ $(uname) != 'Darwin' ] && skip "Not macOS"

    run ./bin/caption \
        480 300 \
        'I am a caption'$'\n''that lives next door' \
        --text-align 'right' \
        $BATS_TMPDIR/caption.png
    echo "$output"

    [ "$status" -eq 0 ]
    diff tests/output/caption_align.png $BATS_TMPDIR/caption.png
}
