bats_require_minimum_version 1.7.0

@test "reads string field from file" {
    run bin/toml tests/gifs/original.toml video.source
    diff -u <(echo "youtube") <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "reads integer field from file" {
    run bin/toml tests/gifs/original.toml expected.frames
    diff -u <(echo "30") <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "returns empty for missing field" {
    run bin/toml tests/gifs/original.toml missing
    diff -u <(echo "") <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "reads string field from stdin" {
    run bash -c 'cat tests/gifs/original.toml | bin/toml - video.file'
    diff -u <(echo "HU2ftCitvyQ") <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "reads integer field from stdin" {
    run bash -c 'cat tests/gifs/original.toml | bin/toml - expected.width'
    diff -u <(echo "640") <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "conflicting string and table errors" {
    run bin/toml tests/toml/conflicting.toml video.crop
    [ "$status" -ne 0 ]
}
