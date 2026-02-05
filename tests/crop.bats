bats_require_minimum_version 1.7.0

source bin/make_gif

ffmpeg_accepts_crop() {
    local crop_filter="$1"
    ffmpeg \
        -f lavfi \
        -i testsrc=size=1920x1080 \
        -vf "${crop_filter:+$crop_filter,}null" \
        -frames:v 1 \
        -f null - \
            2>/dev/null
}

@test "no crop" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video]
        file = 'test'
	EOF

    run get_crop_value "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo '') <(echo "$output")

    run get_crop "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo '') <(echo "$output")

    ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "string centred" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video]
        crop = '200:100'
	EOF

    run get_crop_value "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo '200:100') <(echo "$output")

    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo '') <(echo "$output")

    run get_crop "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo 'crop=200:100') <(echo "$output")

    ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "string positioned" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video]
        crop = '200:100:50:30'
	EOF

    run get_crop_value "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo '200:100:50:30') <(echo "$output")

    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo '') <(echo "$output")

    run get_crop "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo 'crop=200:100:50:30') <(echo "$output")

    ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "width only" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video.crop]
        width = 200
	EOF

    run get_crop_value "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo '200:::') <(echo "$output")

    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo '') <(echo "$output")

    run get_crop "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo 'crop=200') <(echo "$output")

    ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "height only" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video.crop]
        height = 100
	EOF

    run get_crop_value "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo ':100::') <(echo "$output")

    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo 'crop requires width') <(echo "$output")

    ! ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "left only" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video.crop]
        left = 50
	EOF

    run get_crop_value "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo '::50:') <(echo "$output")

    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo 'crop requires width') <(echo "$output")

    ! ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "top only" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video.crop]
        top = 30
	EOF

    run get_crop_value "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo ':::30') <(echo "$output")

    expected_errors=$(sed -e 's/^        //' <<-EOF
        crop requires width
        crop top requires left
	EOF
    )
    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo "$expected_errors") <(echo "$output")

    ! ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "width and height" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video.crop]
        width = 200
        height = 100
	EOF

    run get_crop_value "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo '200:100::') <(echo "$output")

    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo '') <(echo "$output")

    run get_crop "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo 'crop=200:100') <(echo "$output")

    ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "width height and left" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video.crop]
        width = 200
        height = 100
        left = 50
	EOF

    run get_crop_value "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo '200:100:50:') <(echo "$output")

    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo '') <(echo "$output")

    run get_crop "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo 'crop=200:100:50') <(echo "$output")

    ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "width height and top" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video.crop]
        width = 200
        height = 100
        top = 30
	EOF

    run get_crop_value "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo '200:100::30') <(echo "$output")

    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo 'crop top requires left') <(echo "$output")

    ! ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "all four" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video.crop]
        width = 200
        height = 100
        left = 50
        top = 30
	EOF

    run get_crop_value "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo '200:100:50:30') <(echo "$output")

    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo '') <(echo "$output")

    run get_crop "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo 'crop=200:100:50:30') <(echo "$output")

    ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "left and top without dimensions" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video.crop]
        left = 50
        top = 30
	EOF

    run get_crop_value "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo '::50:30') <(echo "$output")

    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo 'crop requires width') <(echo "$output")

    ! ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "zero left" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video.crop]
        width = 200
        height = 100
        left = 0
        top = 30
	EOF

    run get_crop_value "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo '200:100:0:30') <(echo "$output")

    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo '') <(echo "$output")

    run get_crop "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo 'crop=200:100:0:30') <(echo "$output")

    ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "zero top" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video.crop]
        width = 200
        height = 100
        left = 50
        top = 0
	EOF

    run get_crop_value "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo '200:100:50:0') <(echo "$output")

    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo '') <(echo "$output")

    run get_crop "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo 'crop=200:100:50:0') <(echo "$output")

    ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "negative width" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video.crop]
        width = -200
        height = 100
	EOF

    run get_crop_value "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo '-200:100::') <(echo "$output")

    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo 'crop width must be positive') <(echo "$output")

    ! ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "string negative width" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video]
        crop = '-200:100:50:30'
	EOF

    run get_crop_value "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo '-200:100:50:30') <(echo "$output")

    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo 'crop width must be positive') <(echo "$output")

    ! ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "negative height" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video.crop]
        width = 200
        height = -100
	EOF

    run get_crop_value "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo '200:-100::') <(echo "$output")

    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo 'crop height must be positive') <(echo "$output")

    ! ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "negative left" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video.crop]
        width = 200
        height = 100
        left = -50
        top = 30
	EOF

    run get_crop_value "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo '200:100:-50:30') <(echo "$output")

    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo '') <(echo "$output")

    run get_crop "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo 'crop=200:100:-50:30') <(echo "$output")

    ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "negative top" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video.crop]
        width = 200
        height = 100
        left = 50
        top = -30
	EOF

    run get_crop_value "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo '200:100:50:-30') <(echo "$output")

    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo '') <(echo "$output")

    run get_crop "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo 'crop=200:100:50:-30') <(echo "$output")

    ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "zero width" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video.crop]
        width = 0
        height = 100
	EOF

    run get_crop_value "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo '0:100::') <(echo "$output")

    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo 'crop width must be positive') <(echo "$output")

    ! ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "zero height" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video.crop]
        width = 200
        height = 0
	EOF

    run get_crop_value "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo '200:0::') <(echo "$output")

    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo 'crop height must be positive') <(echo "$output")

    ! ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "crop wider than video" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video.crop]
        width = 2000
        height = 100
	EOF

    # centred: left=(1920-2000)/2=-40, right=-40+2000=1960
    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo 'crop exceeds frame width: 1960 > 1920') <(echo "$output")

    ! ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "crop taller than video" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video.crop]
        width = 200
        height = 1200
	EOF

    # centred: top=(1080-1200)/2=-60, bottom=-60+1200=1140
    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo 'crop exceeds frame height: 1140 > 1080') <(echo "$output")

    ! ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "crop exceeds right edge" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video.crop]
        width = 200
        height = 100
        left = 1800
        top = 0
	EOF

    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo 'crop exceeds frame width: 2000 > 1920') <(echo "$output")

    ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "crop exceeds bottom edge" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video.crop]
        width = 200
        height = 100
        left = 0
        top = 1000
	EOF

    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo 'crop exceeds frame height: 1100 > 1080') <(echo "$output")

    ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "crop exceeds both edges" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video.crop]
        width = 200
        height = 100
        left = 1800
        top = 1000
	EOF

    expected_errors=$(sed -e 's/^        //' <<-EOF
        crop exceeds frame width: 2000 > 1920
        crop exceeds frame height: 1100 > 1080
	EOF
    )
    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo "$expected_errors") <(echo "$output")

    ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}

@test "empty crop string" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video]
        crop = ''
	EOF

    run get_crop_value "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo '') <(echo "$output")

    run get_crop "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo '') <(echo "$output")
}

@test "non-numeric width" {
    sed -e 's/^        //' > "$BATS_TEST_TMPDIR/crop.toml" <<-EOF
        [video.crop]
        width = 'foo'
        height = 100
	EOF

    run get_crop_value "$BATS_TEST_TMPDIR/crop.toml"
    diff -u <(echo 'foo:100::') <(echo "$output")

    # bash treats non-numeric as 0, so this triggers "must be positive"
    run validate_crop "$BATS_TEST_TMPDIR/crop.toml" 1920 1080
    diff -u <(echo 'crop width must be positive') <(echo "$output")

    ! ffmpeg_accepts_crop "$(get_crop "$BATS_TEST_TMPDIR/crop.toml")"
}
