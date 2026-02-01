#!/bin/bash

source bin/make_gif

@test palettegen_includes_colours_and_mode {
    expected='[0:v] palettegen=max_colors=128:stats_mode=diff'

    got="$(palettegen_filter tests/gifs/scale.toml)"
    diff -u <(echo "$expected") <(echo "$got")
}
