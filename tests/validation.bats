bats_require_minimum_version 1.7.0

setup() {
    if [ "$(uname)" != 'Darwin' ]; then
        skip "Not macOS"
    fi
}

@test "video start exceeds duration" {
    expected_output=$(sed -e 's/^        //' <<-EOF
         ** video.start ends after video (180 > 152)
	EOF
    )

    run bin/make_gif tests/time_validation/time_start_exceeds.toml "$BATS_TEST_TMPDIR/output.gif" videos/HU2ftCitvyQ.mp4
    diff -u <(echo "$expected_output") <(echo "$output")
    [ $status -eq 1 ]
}

@test "video end exceeds duration" {
    expected_output=$(sed -e 's/^        //' <<-EOF
         ** video end ends after video (160 > 152)
	EOF
    )

    run bin/make_gif tests/time_validation/time_end_exceeds.toml "$BATS_TEST_TMPDIR/output.gif" videos/HU2ftCitvyQ.mp4
    diff -u <(echo "$expected_output") <(echo "$output")
    [ $status -eq 1 ]
}

@test "clip end exceeds duration" {
    expected_output=$(sed -e 's/^        //' <<-EOF
         ** clip 2 ends after video (155 > 152)
	EOF
    )

    run bin/make_gif tests/time_validation/time_clip_exceeds.toml "$BATS_TEST_TMPDIR/output.gif" videos/HU2ftCitvyQ.mp4
    diff -u <(echo "$expected_output") <(echo "$output")
    [ $status -eq 1 ]
}

@test "invalid toml errors" {
    run bin/make_gif tests/toml/conflicting.toml "$BATS_TEST_TMPDIR/output.gif" videos/HU2ftCitvyQ.mp4
    diff -u <(echo "tests/toml/conflicting.toml: Cannot overwrite a value (at line 3, column 12)") <(echo "$output")
    [ $status -ne 0 ]
}
