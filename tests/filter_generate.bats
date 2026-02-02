#!/bin/bash

source bin/make_gif

@test generate_default {
    expected='[0:v] copy [iv]; [iv][1:v] paletteuse='
    expected+='dither=bayer:bayer_scale=4:diff_mode=rectangle'

    got="$(generate_filter tests/gifs/original.toml)"
    diff -u <(echo "$expected") <(echo "$got")
}

@test generate_slowdown {
    expected='[0:v] setpts=1.5*PTS [iv]; [iv][1:v] paletteuse='
    expected+='dither=bayer:bayer_scale=4:diff_mode=rectangle'

    got="$(generate_filter tests/gifs/slowdown.toml)"
    diff -u <(echo "$expected") <(echo "$got")
}

@test generate_captions {
    expected='[0:v] copy [iv]; '
    expected+='[iv][2:v] overlay=(main_w-overlay_w):(main_h-overlay_h)'
    expected+=":enable='between(t,0,0.3)' [v1]; "
    expected+='[v1][3:v] overlay=(main_w-overlay_w):(main_h-overlay_h)'
    expected+=":enable='between(t,0.31,0.6)' [v2]; "
    expected+='[v2][4:v] overlay=(main_w-overlay_w):(main_h-overlay_h)'
    expected+=":enable='between(t,0.61,0.9)' [v3]; "
    expected+='[v3][1:v] paletteuse='
    expected+='dither=bayer:bayer_scale=4:diff_mode=rectangle'

    got="$(generate_filter tests/gifs/captions.toml)"
    diff -u <(echo "$expected") <(echo "$got")
}
