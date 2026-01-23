bats_require_minimum_version 1.7.0

setup() {
    if [ "$(uname)" != 'Darwin' ]; then
        skip "Not macOS"
    fi
}


@test caption_without_args_is_error {
    run ./bin/caption
    echo "$output"
    [ "$status" -eq 2 ]
}

@test missing_font_is_error_not_stacktrace {
    expected_output="Font not found: fonts/nonexistent.ttf"
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --font 'nonexistent.ttf' \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    diff <(echo "$expected_output") <(echo "$output")
    [ "$status" -eq 1 ]
}

@test anchor_top_left {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement 'tl' \
        --guides \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/anchor_tl_sl.png
    diff tests/captions/anchor_tl_sl.png $BATS_TEST_TMPDIR/caption.png
}

@test anchor_top_middle {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement 'tc' \
        --guides \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/anchor_tc_sl.png
    diff tests/captions/anchor_tc_sl.png $BATS_TEST_TMPDIR/caption.png
}

@test anchor_top_right {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement tr \
        --guides \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/anchor_tr_sl.png
    diff tests/captions/anchor_tr_sl.png $BATS_TEST_TMPDIR/caption.png
}

@test anchor_middle_left {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement ml \
        --guides \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/anchor_ml_sl.png
    diff tests/captions/anchor_ml_sl.png $BATS_TEST_TMPDIR/caption.png
}

@test anchor_middle_centre {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement mc \
        --guides \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/anchor_mc_sl.png
    diff tests/captions/anchor_mc_sl.png $BATS_TEST_TMPDIR/caption.png
}

@test anchor_middle_right {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement mr \
        --guides \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/anchor_mr_sl.png
    diff tests/captions/anchor_mr_sl.png $BATS_TEST_TMPDIR/caption.png
}

@test anchor_bottom_left {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement bl \
        --guides \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/anchor_bl_sl.png
    diff tests/captions/anchor_bl_sl.png $BATS_TEST_TMPDIR/caption.png
}

@test anchor_bottom_middle {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement bc \
        --guides \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/anchor_bc_sl.png
    diff tests/captions/anchor_bc_sl.png $BATS_TEST_TMPDIR/caption.png
}

@test anchor_bottom_right {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement br \
        --guides \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/anchor_br_sl.png
    diff tests/captions/anchor_br_sl.png $BATS_TEST_TMPDIR/caption.png
}

@test anchor_top_left_multiline {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption'$'\n''that lives next door' \
        --placement tl \
        --guides \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/anchor_tl_ml.png
    diff tests/captions/anchor_tl_ml.png $BATS_TEST_TMPDIR/caption.png
}

@test anchor_top_middle_multiline {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption'$'\n''that lives next door' \
        --placement tc \
        --guides \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/anchor_tc_ml.png
    diff tests/captions/anchor_tc_ml.png $BATS_TEST_TMPDIR/caption.png
}

@test anchor_top_right_multiline {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption'$'\n''that lives next door' \
        --placement tr \
        --guides \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/anchor_tr_ml.png
    diff tests/captions/anchor_tr_ml.png $BATS_TEST_TMPDIR/caption.png
}

@test anchor_middle_left_multiline {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption'$'\n''that lives next door' \
        --placement ml \
        --guides \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/anchor_ml_ml.png
    diff tests/captions/anchor_ml_ml.png $BATS_TEST_TMPDIR/caption.png
}

@test anchor_middle_centre_multiline {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption'$'\n''that lives next door' \
        --placement mc \
        --guides \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/anchor_mc_ml.png
    diff tests/captions/anchor_mc_ml.png $BATS_TEST_TMPDIR/caption.png
}

@test anchor_middle_right_multiline {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption'$'\n''that lives next door' \
        --placement mr \
        --guides \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/anchor_mr_ml.png
    diff tests/captions/anchor_mr_ml.png $BATS_TEST_TMPDIR/caption.png
}

@test anchor_bottom_left_multiline {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption'$'\n''that lives next door' \
        --placement bl \
        --guides \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/anchor_bl_ml.png
    diff tests/captions/anchor_bl_ml.png $BATS_TEST_TMPDIR/caption.png
}

@test anchor_bottom_middle_multiline {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption'$'\n''that lives next door' \
        --placement bc \
        --guides \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/anchor_bc_ml.png
    diff tests/captions/anchor_bc_ml.png $BATS_TEST_TMPDIR/caption.png
}

@test anchor_bottom_right_multiline {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption'$'\n''that lives next door' \
        --placement br \
        --guides \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/anchor_br_ml.png
    diff tests/captions/anchor_br_ml.png $BATS_TEST_TMPDIR/caption.png
}

@test placement_negative {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement='-40,-40' \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/placement_negative.png
    diff tests/captions/placement_negative.png $BATS_TEST_TMPDIR/caption.png
}

@test placement_positive {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement='100,200' \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/placement_positive.png
    diff tests/captions/placement_positive.png $BATS_TEST_TMPDIR/caption.png
}

@test colour_default {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement mc \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/colour_default.png
    diff tests/captions/colour_default.png $BATS_TEST_TMPDIR/caption.png
}
@test colour_yellow {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --colour yellow \
        --placement mc \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/colour_yellow.png
    diff tests/captions/colour_yellow.png $BATS_TEST_TMPDIR/caption.png
}

@test stroke_colour_default {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement mc \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/stroke_colour_default.png
    diff tests/captions/stroke_colour_default.png $BATS_TEST_TMPDIR/caption.png
}
@test stroke_colour_red {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --stroke-colour red \
        --placement mc \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/stroke_colour_red.png
    diff tests/captions/stroke_colour_red.png $BATS_TEST_TMPDIR/caption.png
}

@test stroke_width_large {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --stroke-width 10 \
        --placement mc \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/stroke_width_large.png
    diff tests/captions/stroke_width_large.png $BATS_TEST_TMPDIR/caption.png
}

@test fontsize_default {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement mc \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/fontsize_default.png
    diff tests/captions/fontsize_default.png $BATS_TEST_TMPDIR/caption.png
}

@test fontsize_small {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --font-size 20 \
        --placement mc \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/fontsize_small.png
    diff tests/captions/fontsize_small.png $BATS_TEST_TMPDIR/caption.png
}
@test fontsize_large {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --font-size 100 \
        --placement mc \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/fontsize_large.png
    diff tests/captions/fontsize_large.png $BATS_TEST_TMPDIR/caption.png
}

@test font_assistant_bold {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --font assistant-bold.ttf \
        --placement mc \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp --placement mc $BATS_TEST_TMPDIR/caption.png tests/captions/font_assistant_bold.png
    diff tests/captions/font_assistant_bold.png $BATS_TEST_TMPDIR/caption.png
}


@test font_too_small_raises_error {
    run ./bin/caption \
        50 \
        50 \
        'This text is far too long to fit' \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    diff <(echo "Text too large to fit in image at font size 6") <(echo "$output")
    [ "$status" -eq 1 ]
}

@test resize_basic {
    run ./bin/caption \
        200 \
        100 \
        'Testing resize' \
        --font-size 80 \
        --stroke-width 0 \
        --colour black \
        --placement mc \
        --guides \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/resize_basic.png
    diff tests/captions/resize_basic.png $BATS_TEST_TMPDIR/caption.png
}

@test resize_multiline {
    run ./bin/caption \
        200 \
        100 \
        'Testing'$'\n''resize' \
        --font-size 60 \
        --placement mc \
        --guides \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/resize_multiline.png
    diff tests/captions/resize_multiline.png $BATS_TEST_TMPDIR/caption.png
}
@test resize_with_stroke {
    run ./bin/caption \
        200 \
        100 \
        'Testing stroke width' \
        --stroke-width 10 \
        --font-size 60 \
        --placement mc \
        --guides \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/resize_with_stroke.png
    diff tests/captions/resize_with_stroke.png $BATS_TEST_TMPDIR/caption.png
    [ "$status" -eq 0 ]
}

@test stroke_width_default {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement mc \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/stroke_width_default.png
    diff tests/captions/stroke_width_default.png $BATS_TEST_TMPDIR/caption.png
}
@test stroke_width_zero {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --stroke-width 0 \
        --colour black \
        --placement mc \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/stroke_width_zero.png
    diff tests/captions/stroke_width_zero.png $BATS_TEST_TMPDIR/caption.png
}

@test margin_top_left {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --margin 40 \
        --placement tl \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/margin_tl.png
    diff tests/captions/margin_tl.png $BATS_TEST_TMPDIR/caption.png
}

@test margin_top_right {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --margin 40 \
        --placement tr \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/margin_tr.png
    diff tests/captions/margin_tr.png $BATS_TEST_TMPDIR/caption.png
}

@test margin_bottom_left {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --margin 40 \
        --placement bl \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/margin_bl.png
    diff tests/captions/margin_bl.png $BATS_TEST_TMPDIR/caption.png
}

@test margin_bottom_right {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --margin 40 \
        --placement br \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp $BATS_TEST_TMPDIR/caption.png tests/captions/margin_br.png
    diff tests/captions/margin_br.png $BATS_TEST_TMPDIR/caption.png
}

@test font_lato_black {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --font lato-black.ttf \
        --placement mc \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp --placement mc $BATS_TEST_TMPDIR/caption.png tests/captions/font_lato_black.png
    diff tests/captions/font_lato_black.png $BATS_TEST_TMPDIR/caption.png
}

@test font_oita {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --font oita.otf \
        --placement mc \
        $BATS_TEST_TMPDIR/caption.png

    echo "$output"
    [ "$status" -eq 0 ]
    # cp --placement mc $BATS_TEST_TMPDIR/caption.png tests/captions/font_oita.png
    diff tests/captions/font_oita.png $BATS_TEST_TMPDIR/caption.png
}
