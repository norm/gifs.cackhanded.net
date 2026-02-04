bats_require_minimum_version 1.7.0

source script/carve

@test "movie with year and release info" {
    expected=$(sed -e 's/^        //' <<-EOF
        type=movie
        title='Back to the Future'
        year=1985
	EOF
    )

    run guess_video_type 'Back.to.the.Future.1985.2160p.UHD.BluRay.x265.10bit.HDR.DDP5.1-LAMA.mkv'
    diff -u <(echo "$expected") <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "movie without release info" {
    expected=$(sed -e 's/^        //' <<-EOF
        type=movie
        title='The Matrix'
        year=1999
	EOF
    )

    run guess_video_type 'The.Matrix.1999.mkv'
    diff -u <(echo "$expected") <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "youtube video id" {
    expected=$(sed -e 's/^        //' <<-EOF
        type=youtube
        video_id=HU2ftCitvyQ
	EOF
    )

    run guess_video_type 'HU2ftCitvyQ.mp4'
    diff -u <(echo "$expected") <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "youtube video id with brackets" {
    expected=$(sed -e 's/^        //' <<-EOF
        type=youtube
        title='Some Video Title'
        video_id=HU2ftCitvyQ
	EOF
    )

    run guess_video_type 'Some Video Title [HU2ftCitvyQ].mp4'
    diff -u <(echo "$expected") <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "tv episode s01e05 format" {
    expected=$(sed -e 's/^        //' <<-EOF
        type=tv
        title='zim'
        season=1
        episode=5
	EOF
    )

    run guess_video_type 'zim_s01e05.m4v'
    diff -u <(echo "$expected") <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "tv episode from directory path" {
    expected=$(sed -e 's/^        //' <<-EOF
        type=tv
        title='invader zim'
        season=1
        episode=5
	EOF
    )

    run guess_video_type 'invader zim/1x05.mp4'
    diff -u <(echo "$expected") <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "tv episode from nested directory structure" {
    expected=$(sed -e 's/^        //' <<-EOF
        type=tv
        title='Invader Zim'
        season=1
        episode=5
	EOF
    )

    run guess_video_type 'Invader Zim/Season 1/05 - Attack of the Saucer Morons - The Wettening.m4v'
    diff -u <(echo "$expected") <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "tv episode S01E05 uppercase" {
    expected=$(sed -e 's/^        //' <<-EOF
        type=tv
        title='Breaking Bad'
        season=2
        episode=10
	EOF
    )

    run guess_video_type 'Breaking.Bad.S02E10.720p.BluRay.mkv'
    diff -u <(echo "$expected") <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "tv episode 1x05 format" {
    expected=$(sed -e 's/^        //' <<-EOF
        type=tv
        title='Firefly'
        season=1
        episode=5
	EOF
    )

    run guess_video_type 'Firefly.1x05.mkv'
    diff -u <(echo "$expected") <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "unknown format returns unknown" {
    expected=$(sed -e 's/^        //' <<-EOF
        type=unknown
        title='some_random_file'
	EOF
    )

    run guess_video_type 'some_random_file.mkv'
    diff -u <(echo "$expected") <(echo "$output")
    [ "$status" -eq 0 ]
}
