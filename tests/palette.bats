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

@test "palette does not duplicate colours" {
    run ./bin/palette \
        tests/gifs/sol-levante-hdr.tiled.png \
        "$BATS_TEST_TMPDIR/no_dupe.png" \
        --add '#ff00ff' \
        --add '#ff00ff' \
        --add '#ff00ff' \
        --list

    [ "$status" -eq 0 ]
    count=$(echo "$output" | grep -c '#ff00ff')
    diff <(echo "1") <(echo "$count")
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

@test "weighted frames changes palette" {
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
        --weighted-frames '1-7'

    ! cmp -s "$BATS_TEST_TMPDIR/no_weight.png" "$BATS_TEST_TMPDIR/weighted.png"
}

@test "weighted frames splits palette 40/60" {
    run ./bin/palette \
        tests/gifs/sol-levante-hdr.tiled.png \
        "$BATS_TEST_TMPDIR/split.png" \
        --colours 16 \
        --frame-count 34 \
        --weighted-frames '1-7' \
        --rescue 0

    [ "$status" -eq 0 ]
    echo "$output" | grep -q '6 (weighted)'
}

@test "weighted frames with individual frame syntax" {
    run ./bin/palette \
        tests/gifs/sol-levante-hdr.tiled.png \
        "$BATS_TEST_TMPDIR/individual.png" \
        --colours 16 \
        --frame-count 34 \
        --weighted-frames '1 2 3 14'

    [ "$status" -eq 0 ]
    echo "$output" | grep -q '(weighted)'
}

@test "weighted frames with mixed syntax" {
    run ./bin/palette \
        tests/gifs/sol-levante-hdr.tiled.png \
        "$BATS_TEST_TMPDIR/mixed.png" \
        --colours 16 \
        --frame-count 34 \
        --weighted-frames '1 2 3-7'

    [ "$status" -eq 0 ]
    echo "$output" | grep -q '(weighted)'
}
