#!/bin/bash

source bin/make_gif

@test palettegen_no_args {
    expected='[0:v] palettegen=max_colors=64:stats_mode=diff'

    got="$(palettegen_filter tests/config/original.toml)"
    echo GOT=$got
    echo EXP=$expected
    [ "$got" = "$expected" ]
}

@test palettegen_fps {
    expected='[0:v] fps=10,palettegen=max_colors=64:stats_mode=diff'

    got="$(palettegen_filter tests/config/fps.toml)"
    echo GOT=$got
    echo EXP=$expected
    [ "$got" = "$expected" ]
}

@test palettegen_fps_scale_colours {
    expected='[0:v] fps=10,scale=480:-1,'
    expected+='palettegen=max_colors=128:stats_mode=diff'

    got="$(palettegen_filter tests/config/scale.toml)"
    echo GOT=$got
    echo EXP=$expected
    [ "$got" = "$expected" ]
}

@test palettegen_fps_crop {
    expected='[0:v] fps=10,crop=200:100,'
    expected+='palettegen=max_colors=64:stats_mode=diff'

    got="$(palettegen_filter tests/config/crop.toml)"
    echo GOT=$got
    echo EXP=$expected
    [ "$got" = "$expected" ]
}

@test palettegen_clips {
    expected='[0:v] fps=16,trim=start=10:end=12,setpts=PTS-STARTPTS [c1]; '
    expected+='[0:v] fps=16,trim=start=70:end=72,setpts=PTS-STARTPTS [c2]; '
    expected+='[c1][c2] concat=n=2:v=1,crop=200:100,scale=320:-1 [cv]; '
    expected+='[cv] palettegen=max_colors=64:stats_mode=diff'

    got="$(palettegen_filter tests/config/clips.toml)"
    echo GOT=$got
    echo EXP=$expected
    [ "$got" = "$expected" ]
}
