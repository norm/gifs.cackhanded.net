bats_require_minimum_version 1.7.0

setup() {
    if [ "$(uname)" != 'Darwin' ]; then
        skip "Not macOS"
    fi
    mkdir -p temp
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
        temp/missing_font.png

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
        temp/anchor_tl_sl.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/anchor_tl_sl.png temp/anchor_tl_sl.png
}

@test anchor_top_middle {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement 'tc' \
        --guides \
        temp/anchor_tc_sl.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/anchor_tc_sl.png temp/anchor_tc_sl.png
}

@test anchor_top_right {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement tr \
        --guides \
        temp/anchor_tr_sl.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/anchor_tr_sl.png temp/anchor_tr_sl.png
}

@test anchor_middle_left {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement ml \
        --guides \
        temp/anchor_ml_sl.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/anchor_ml_sl.png temp/anchor_ml_sl.png
}

@test anchor_middle_centre {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement mc \
        --guides \
        temp/anchor_mc_sl.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/anchor_mc_sl.png temp/anchor_mc_sl.png
}

@test anchor_middle_right {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement mr \
        --guides \
        temp/anchor_mr_sl.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/anchor_mr_sl.png temp/anchor_mr_sl.png
}

@test anchor_bottom_left {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement bl \
        --guides \
        temp/anchor_bl_sl.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/anchor_bl_sl.png temp/anchor_bl_sl.png
}

@test anchor_bottom_middle {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement bc \
        --guides \
        temp/anchor_bc_sl.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/anchor_bc_sl.png temp/anchor_bc_sl.png
}

@test anchor_bottom_right {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement br \
        --guides \
        temp/anchor_br_sl.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/anchor_br_sl.png temp/anchor_br_sl.png
}

@test anchor_top_left_multiline {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption'$'\n''that lives next door' \
        --placement tl \
        --guides \
        temp/anchor_tl_ml.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/anchor_tl_ml.png temp/anchor_tl_ml.png
}

@test anchor_top_middle_multiline {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption'$'\n''that lives next door' \
        --placement tc \
        --guides \
        temp/anchor_tc_ml.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/anchor_tc_ml.png temp/anchor_tc_ml.png
}

@test anchor_top_right_multiline {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption'$'\n''that lives next door' \
        --placement tr \
        --guides \
        temp/anchor_tr_ml.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/anchor_tr_ml.png temp/anchor_tr_ml.png
}

@test anchor_middle_left_multiline {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption'$'\n''that lives next door' \
        --placement ml \
        --guides \
        temp/anchor_ml_ml.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/anchor_ml_ml.png temp/anchor_ml_ml.png
}

@test anchor_middle_centre_multiline {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption'$'\n''that lives next door' \
        --placement mc \
        --guides \
        temp/anchor_mc_ml.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/anchor_mc_ml.png temp/anchor_mc_ml.png
}

@test anchor_middle_right_multiline {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption'$'\n''that lives next door' \
        --placement mr \
        --guides \
        temp/anchor_mr_ml.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/anchor_mr_ml.png temp/anchor_mr_ml.png
}

@test anchor_bottom_left_multiline {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption'$'\n''that lives next door' \
        --placement bl \
        --guides \
        temp/anchor_bl_ml.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/anchor_bl_ml.png temp/anchor_bl_ml.png
}

@test anchor_bottom_middle_multiline {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption'$'\n''that lives next door' \
        --placement bc \
        --guides \
        temp/anchor_bc_ml.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/anchor_bc_ml.png temp/anchor_bc_ml.png
}

@test anchor_bottom_right_multiline {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption'$'\n''that lives next door' \
        --placement br \
        --guides \
        temp/anchor_br_ml.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/anchor_br_ml.png temp/anchor_br_ml.png
}

@test placement_negative {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement='-40,-40' \
        temp/placement_negative.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/placement_negative.png temp/placement_negative.png
}

@test placement_positive {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement='100,200' \
        temp/placement_positive.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/placement_positive.png temp/placement_positive.png
}

@test colour_default {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement mc \
        temp/colour_default.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/colour_default.png temp/colour_default.png
}
@test colour_yellow {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --colour yellow \
        --placement mc \
        temp/colour_yellow.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/colour_yellow.png temp/colour_yellow.png
}

@test stroke_colour_default {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement mc \
        temp/stroke_colour_default.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/stroke_colour_default.png temp/stroke_colour_default.png
}
@test stroke_colour_red {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --stroke-colour red \
        --placement mc \
        temp/stroke_colour_red.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/stroke_colour_red.png temp/stroke_colour_red.png
}

@test stroke_width_large {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --stroke-width 10 \
        --placement mc \
        temp/stroke_width_large.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/stroke_width_large.png temp/stroke_width_large.png
}

@test fontsize_default {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement mc \
        temp/fontsize_default.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/fontsize_default.png temp/fontsize_default.png
}

@test fontsize_small {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --font-size 20 \
        --placement mc \
        temp/fontsize_small.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/fontsize_small.png temp/fontsize_small.png
}
@test fontsize_large {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --font-size 100 \
        --placement mc \
        temp/fontsize_large.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/fontsize_large.png temp/fontsize_large.png
}

@test font_assistant_bold {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --font assistant-bold.ttf \
        --placement mc \
        temp/font_assistant_bold.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/font_assistant_bold.png temp/font_assistant_bold.png
}


@test font_too_small_raises_error {
    run ./bin/caption \
        50 \
        50 \
        'This text is far too long to fit' \
        temp/font_too_small.png

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
        temp/resize_basic.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/resize_basic.png temp/resize_basic.png
}

@test resize_multiline {
    run ./bin/caption \
        200 \
        100 \
        'Testing'$'\n''resize' \
        --font-size 60 \
        --placement mc \
        --guides \
        temp/resize_multiline.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/resize_multiline.png temp/resize_multiline.png
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
        temp/resize_with_stroke.png

    echo "$output"
    diff tests/captions/resize_with_stroke.png temp/resize_with_stroke.png
    [ "$status" -eq 0 ]
}

@test stroke_width_default {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --placement mc \
        temp/stroke_width_default.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/stroke_width_default.png temp/stroke_width_default.png
}
@test stroke_width_zero {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --stroke-width 0 \
        --colour black \
        --placement mc \
        temp/stroke_width_zero.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/stroke_width_zero.png temp/stroke_width_zero.png
}

@test margin_top_left {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --margin 40 \
        --placement tl \
        temp/margin_tl.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/margin_tl.png temp/margin_tl.png
}

@test margin_top_right {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --margin 40 \
        --placement tr \
        temp/margin_tr.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/margin_tr.png temp/margin_tr.png
}

@test margin_bottom_left {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --margin 40 \
        --placement bl \
        temp/margin_bl.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/margin_bl.png temp/margin_bl.png
}

@test margin_bottom_right {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --margin 40 \
        --placement br \
        temp/margin_br.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/margin_br.png temp/margin_br.png
}

@test font_lato_black {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --font lato-black.ttf \
        --placement mc \
        temp/font_lato_black.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/font_lato_black.png temp/font_lato_black.png
}

@test font_raleway {
    run ./bin/caption \
        480 \
        300 \
        'I am a caption' \
        --font raleway-regular.ttf \
        --placement mc \
        temp/font_raleway.png

    echo "$output"
    [ "$status" -eq 0 ]
    diff tests/captions/font_raleway.png temp/font_raleway.png
}
