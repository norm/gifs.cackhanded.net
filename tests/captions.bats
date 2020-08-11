
@test caption_without_args_is_error {
    run ./bin/caption
    echo "$output"

    [ "$status" -eq 2 ]
}

@test basic_caption {
    run ./bin/caption 480 300 'I am a caption' $BATS_TMPDIR/caption.png
    echo "$output"

    [ "$status" -eq 0 ]
    diff tests/output/caption.png $BATS_TMPDIR/caption.png
}

@test basic_caption_centred {
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
    run ./bin/caption \
        480 300 \
        'I am a caption'$'\n''that lives next door' \
        --text-align 'right' \
        $BATS_TMPDIR/caption.png
    echo "$output"

    [ "$status" -eq 0 ]
    diff tests/output/caption_align.png $BATS_TMPDIR/caption.png
}
