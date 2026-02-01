bats_require_minimum_version 1.7.0


@test "palette without args is error" {
    run ./bin/palette
    [ "$status" -eq 2 ]
}

@test "palette requires input and output" {
    run ./bin/palette tests/gifs/sol-levante-hdr.tiled.png
    [ "$status" -eq 2 ]
}

@test "palette generates 16x16 png" {
    run ./bin/palette \
        tests/gifs/sol-levante-hdr.tiled.png \
        "$BATS_TEST_TMPDIR/size.png"

    [ "$status" -eq 0 ]

    size=$(file "$BATS_TEST_TMPDIR/size.png" | grep -o '[0-9]* x [0-9]*')
    diff <(echo "16 x 16") <(echo "$size")
}

@test "palette respects colour count" {
    run ./bin/palette \
        tests/gifs/sol-levante-hdr.tiled.png \
        "$BATS_TEST_TMPDIR/colours_8.png" \
        --colours 8 \
        --list

    [ "$status" -eq 0 ]
    count=$(echo "$output" | grep -c '^#')
    diff <(echo "8") <(echo "$count")
    diff tests/palette/colours_8.png "$BATS_TEST_TMPDIR/colours_8.png"
}

@test "palette allows exactly 256 colours" {
    run ./bin/palette \
        tests/gifs/sol-levante-hdr.tiled.png \
        "$BATS_TEST_TMPDIR/max.png" \
        --colours 249 \
        --range '#000000' '#ffffff' \
        --add '#123456'

    [ "$status" -eq 0 ]
}

@test "palette errors when exceeding 256 colours" {
    run ./bin/palette \
        tests/gifs/sol-levante-hdr.tiled.png \
        "$BATS_TEST_TMPDIR/overflow.png" \
        --colours 250 \
        --range '#000000' '#ffffff' \
        --range '#ff0000' '#00ff00'

    diff <(echo "error: 262 colours exceeds 256 limit") <(echo "$output")
    [ "$status" -eq 1 ]
}

@test "palette does not duplicate colours" {
    run ./bin/palette \
        tests/palette/solid_grey.png \
        "$BATS_TEST_TMPDIR/solid_grey.png" \
        --colours 8 \
        --list

    [ "$status" -eq 0 ]
    count=$(echo "$output" | grep -c '^#')
    diff <(echo "1") <(echo "$count")
}

@test "spot colour is added to palette" {
    run ./bin/palette \
        tests/gifs/sol-levante-hdr.tiled.png \
        "$BATS_TEST_TMPDIR/spot.png" \
        --add '#ff00ff' \
        --list

    [ "$status" -eq 0 ]
    echo "$output" | grep -q '#ff00ff'
    diff tests/palette/spot.png "$BATS_TEST_TMPDIR/spot.png"
}

@test "multiple spot colours are added" {
    run ./bin/palette \
        tests/gifs/sol-levante-hdr.tiled.png \
        "$BATS_TEST_TMPDIR/multi_spot.png" \
        --add '#ff00ff' \
        --add '#00ffff' \
        --list

    [ "$status" -eq 0 ]
    echo "$output" | grep -q '#ff00ff'
    echo "$output" | grep -q '#00ffff'
    diff tests/palette/multi_spot.png "$BATS_TEST_TMPDIR/multi_spot.png"
}

@test "colour range adds interpolated colours" {
    run ./bin/palette \
        tests/gifs/sol-levante-hdr.tiled.png \
        "$BATS_TEST_TMPDIR/range.png" \
        --range '#ffffff' '#000000' \
        --list

    [ "$status" -eq 0 ]
    echo "$output" | grep -q '#ffffff'
    echo "$output" | grep -q '#000000'
    echo "$output" | grep -qE '#(333333|666666|999999|cccccc)'
    diff tests/palette/range.png "$BATS_TEST_TMPDIR/range.png"
}

@test "frame weighting with individual frames" {
    ./bin/palette \
        tests/gifs/sol-levante-hdr.tiled.png \
        "$BATS_TEST_TMPDIR/weight_range.png" \
        --colours 16 \
        --frame-count 34 \
        --weight-frames '0 1 2 13' \
        --weighting 2 \
        --save-weighted "$BATS_TEST_TMPDIR/weighted_image.png"

    diff tests/palette/weighted_frames_4.png "$BATS_TEST_TMPDIR/weighted_image.png"

    ./bin/palette \
        tests/gifs/sol-levante-hdr.tiled.png \
        "$BATS_TEST_TMPDIR/weight_range.png" \
        --colours 16 \
        --frame-count 34 \
        --weight-frames '0 13 1 2' \
        --weighting 2 \
        --save-weighted "$BATS_TEST_TMPDIR/weighted_image.png"

    diff tests/palette/weighted_frames_4.png "$BATS_TEST_TMPDIR/weighted_image.png"
}

@test "frame weighting with range syntax" {
    ./bin/palette \
        tests/gifs/sol-levante-hdr.tiled.png \
        "$BATS_TEST_TMPDIR/weight_range.png" \
        --colours 16 \
        --frame-count 34 \
        --weight-frames '0-6' \
        --weighting 2 \
        --save-weighted "$BATS_TEST_TMPDIR/weighted_image.png"

    diff tests/palette/weighted_frames_7.png "$BATS_TEST_TMPDIR/weighted_image.png"
}

@test "frame weighting with mixed syntax" {
    ./bin/palette \
        tests/gifs/sol-levante-hdr.tiled.png \
        "$BATS_TEST_TMPDIR/weight_mixed.png" \
        --colours 16 \
        --frame-count 34 \
        --weight-frames '0 1 2-6' \
        --weighting 2 \
        --save-weighted "$BATS_TEST_TMPDIR/weighted_image.png"

    diff tests/palette/weighted_frames_7.png "$BATS_TEST_TMPDIR/weighted_image.png"
}

@test "frame weighting changes palette" {
    ./bin/palette \
        tests/gifs/sol-levante-hdr.tiled.png \
        "$BATS_TEST_TMPDIR/no_weight.png" \
        --colours 16 \
        --frame-count 34

    ./bin/palette \
        tests/gifs/sol-levante-hdr.tiled.png \
        "$BATS_TEST_TMPDIR/weighted.png" \
        --colours 16 \
        --frame-count 34 \
        --weight-frames '0-6' \
        --weighting 4

    ! cmp -s "$BATS_TEST_TMPDIR/no_weight.png" "$BATS_TEST_TMPDIR/weighted.png"
}
