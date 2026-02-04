bats_require_minimum_version 1.7.0

source script/carve

@test "basic title" {
    run slugify 'Hello World'
    diff -u <(echo 'hello-world') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "removes punctuation" {
    run slugify "What's up, Doc?"
    diff -u <(echo 'whats-up-doc') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "collapses multiple spaces" {
    run slugify 'Too   Many    Spaces'
    diff -u <(echo 'too-many-spaces') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "handles leading and trailing spaces" {
    run slugify '  Padded Title  '
    diff -u <(echo 'padded-title') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "preserves numbers" {
    run slugify 'Back to the Future 2'
    diff -u <(echo 'back-to-the-future-2') <(echo "$output")
    [ "$status" -eq 0 ]
}
