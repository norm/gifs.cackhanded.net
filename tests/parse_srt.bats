bats_require_minimum_version 1.7.0

source script/carve

@test "parse_srt joins multi-line subtitles" {
    expected=$(sed -e 's/^        //' <<-EOF
        1|00:00:06,000|00:00:08,500|Great Scott!
        2|00:00:01,000|00:00:03,500|Roads?
        3|00:00:03,600|00:00:05,200|Where we're going, we don't need roads.
	EOF
    )

    run parse_srt 'tests/srt/multiline.srt'
    diff -u <(echo "$expected") <(echo "$output")
    [ "$status" -eq 0 ]
}
