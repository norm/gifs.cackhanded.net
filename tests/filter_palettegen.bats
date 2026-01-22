#!/bin/bash

source bin/make_gif

@test palettegen_no_args {
    expected='[0:v] palettegen=max_colors=64:stats_mode=diff'

    got="$(palettegen_filter tests/gifs/original.toml)"
    diff -u <(echo "$expected") <(echo "$got")
}

@test palettegen_brighten {
    expected='[0:v] eq=brightness=0.25,'
    expected+='palettegen=max_colors=64:stats_mode=diff'

    got="$(palettegen_filter tests/gifs/brighten.toml)"
    diff -u <(echo "$expected") <(echo "$got")
}

@test palettegen_denoise {
    expected='[0:v] hqdn3d,'
    expected+='palettegen=max_colors=64:stats_mode=diff'

    got="$(palettegen_filter tests/gifs/denoise.toml)"
    diff -u <(echo "$expected") <(echo "$got")
}

@test palettegen_fps {
    expected='[0:v] fps=10,palettegen=max_colors=64:stats_mode=diff'

    got="$(palettegen_filter tests/gifs/fps.toml)"
    diff -u <(echo "$expected") <(echo "$got")
}

@test palettegen_fps_scale_colours {
    expected='[0:v] fps=10,scale=480:-1,'
    expected+='palettegen=max_colors=128:stats_mode=diff'

    got="$(palettegen_filter tests/gifs/scale.toml)"
    diff -u <(echo "$expected") <(echo "$got")
}

@test palettegen_fps_crop {
    expected='[0:v] fps=10,crop=200:100,'
    expected+='palettegen=max_colors=64:stats_mode=diff'

    got="$(palettegen_filter tests/gifs/crop.toml)"
    diff -u <(echo "$expected") <(echo "$got")
}

@test palettegen_clips {
    expected='[0:v] fps=16,trim=start=10:end=12,setpts=PTS-STARTPTS [c1]; '
    expected+='[0:v] fps=16,trim=start=70:end=72,setpts=PTS-STARTPTS [c2]; '
    expected+='[c1][c2] concat=n=2:v=1,crop=200:100,scale=320:-1 [cv]; '
    expected+='[cv] palettegen=max_colors=64:stats_mode=diff'

    got="$(palettegen_filter tests/gifs/clips.toml)"
    diff -u <(echo "$expected") <(echo "$got")
}
