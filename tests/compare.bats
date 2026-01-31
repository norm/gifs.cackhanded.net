bats_require_minimum_version 1.7.0

setup() {
    if [ "$(uname)" != 'Darwin' ]; then
        skip "Not macOS"
    fi
}

@test compare_original {
    ./script/compare_frames_fuzzed tests/gifs/original.toml
}

@test compare_fps {
    ./script/compare_frames_fuzzed tests/gifs/fps.toml
}

@test compare_scale {
    ./script/compare_frames_fuzzed tests/gifs/scale.toml
}

@test compare_crop {
    ./script/compare_frames_fuzzed tests/gifs/crop.toml
}

@test compare_slowdown {
    ./script/compare_frames_fuzzed tests/gifs/slowdown.toml
}

@test compare_brighten {
    ./script/compare_frames_fuzzed tests/gifs/brighten.toml
}

@test compare_denoise {
    ./script/compare_frames_fuzzed tests/gifs/denoise.toml
}

@test compare_lossy {
    ./script/compare_frames_fuzzed tests/gifs/lossy.toml
}

@test compare_clips {
    ./script/compare_frames_fuzzed tests/gifs/clips.toml
}

@test compare_clips_brighten {
    ./script/compare_frames_fuzzed tests/gifs/clips_brighten.toml
}

@test compare_clips_denoise {
    ./script/compare_frames_fuzzed tests/gifs/clips_denoise.toml
}

@test compare_clips_slowdown {
    ./script/compare_frames_fuzzed tests/gifs/clips_slowdown.toml
}

@test compare_captions {
    ./script/compare_frames_fuzzed tests/gifs/captions.toml
}

@test compare_captions_type {
    GIF_TYPE_SETS=tests/gifs/type_sets.toml ./script/compare_frames_fuzzed tests/gifs/captions_type.toml
}

@test compare_captions_noscale {
    ./script/compare_frames_fuzzed tests/gifs/captions_noscale.toml
}

@test compare_clips_captions {
    ./script/compare_frames_fuzzed tests/gifs/clips_captions.toml
}

@test compare_captions_colours {
    ./script/compare_frames_fuzzed tests/gifs/captions_colours.toml
}

@test compare_hdr_tonemapped {
    ./script/compare_frames_fuzzed tests/gifs/sol-levante-hdr.toml
}
