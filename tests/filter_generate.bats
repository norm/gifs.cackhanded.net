#!/bin/bash

source bin/make_gif

@test generate_no_args {
    expected='[0:v] scale=w=in_w:h=in_h [iv]; [iv][1:v] paletteuse='
    expected+='dither=bayer:bayer_scale=4:diff_mode=rectangle'

    got="$(generate_filter tests/config/original.toml)"
    echo "GOT='$got'"
    echo "EXP='$expected'"
    [ "$got" = "$expected" ]
}

@test generate_fps {
    expected='[0:v] fps=10 [iv]; [iv][1:v] paletteuse='
    expected+='dither=bayer:bayer_scale=4:diff_mode=rectangle'

    got="$(generate_filter tests/config/fps.toml)"
    echo "GOT='$got'"
    echo "EXP='$expected'"
    [ "$got" = "$expected" ]
}

@test generate_fps_scale_dither {
    expected='[0:v] fps=10,scale=480:-1 [iv]; [iv][1:v] paletteuse='
    expected+='dither=floyd_steinberg:diff_mode=rectangle'

    got="$(generate_filter tests/config/scale.toml)"
    echo "GOT='$got'"
    echo "EXP='$expected'"
    [ "$got" = "$expected" ]
}

@test generate_fps_crop {
    expected='[0:v] fps=10,crop=200:100 [iv]; [iv][1:v] paletteuse='
    expected+='dither=bayer:bayer_scale=4:diff_mode=rectangle'

    got="$(generate_filter tests/config/crop.toml)"
    echo "GOT='$got'"
    echo "EXP='$expected'"
    [ "$got" = "$expected" ]
}

@test generate_clips {
    expected='[0:v] fps=16,trim=start=10:end=12,setpts=PTS-STARTPTS [c1]; '
    expected+='[0:v] fps=16,trim=start=70:end=72,setpts=PTS-STARTPTS [c2]; '
    expected+='[c1][c2] concat=n=2:v=1,crop=200:100,scale=320:-1 [cv]; '
    expected+='[cv][1:v] paletteuse='
    expected+='dither=bayer:bayer_scale=4:diff_mode=rectangle'

    got="$(generate_filter tests/config/clips.toml)"
    echo "GOT='$got'"
    echo "EXP='$expected'"
    [ "$got" = "$expected" ]
}

@test generate_captions {
    expected='[0:v] fps=18,scale=480:-1 [iv]; '
    expected+='[iv][2:v] overlay=(main_w-overlay_w):(main_h-overlay_h)'
    expected+=":enable='between(t,0,0.3)' [v1]; "
    expected+='[v1][3:v] overlay=(main_w-overlay_w):(main_h-overlay_h)'
    expected+=":enable='between(t,0.31,0.6)' [v2]; "
    expected+='[v2][4:v] overlay=(main_w-overlay_w):(main_h-overlay_h)'
    expected+=":enable='between(t,0.61,0.9)' [v3]; "
    expected+='[v3][1:v] paletteuse='
    expected+='dither=bayer:bayer_scale=4:diff_mode=rectangle'

    got="$(generate_filter tests/config/captions.toml)"
    echo "GOT='$got'"
    echo "EXP='$expected'"
    [ "$got" = "$expected" ]
}

@test generate_captions_noscale {
    expected='[0:v] scale=w=in_w:h=in_h [iv]; '
    expected+='[iv][2:v] overlay=(main_w-overlay_w):(main_h-overlay_h)'
    expected+=":enable='between(t,0,0.5)' [v1]; "
    expected+='[v1][3:v] overlay=(main_w-overlay_w):(main_h-overlay_h)'
    expected+=":enable='between(t,0.51,1)' [v2]; "
    expected+='[v2][1:v] paletteuse='
    expected+='dither=bayer:bayer_scale=4:diff_mode=rectangle'

    got="$(generate_filter tests/config/captions_noscale.toml)"
    echo "GOT='$got'"
    echo "EXP='$expected'"
    [ "$got" = "$expected" ]
}

@test generate_clips_captions {
    expected='[0:v] fps=18,trim=start=10:end=12,setpts=PTS-STARTPTS [c1]; '
    expected+='[0:v] fps=18,trim=start=70:end=72,setpts=PTS-STARTPTS [c2]; '
    expected+='[c1][c2] concat=n=2:v=1,scale=480:-1 [cv]; '
    expected+='[cv][2:v] overlay=(main_w-overlay_w):(main_h-overlay_h)'
    expected+=":enable='between(t,0,0.3)' [v1]; "
    expected+='[v1][3:v] overlay=(main_w-overlay_w):(main_h-overlay_h)'
    expected+=":enable='between(t,0.31,0.6)' [v2]; "
    expected+='[v2][4:v] overlay=(main_w-overlay_w):(main_h-overlay_h)'
    expected+=":enable='between(t,0.61,0.9)' [v3]; "
    expected+='[v3][1:v] paletteuse='
    expected+='dither=bayer:bayer_scale=4:diff_mode=rectangle'

    got="$(generate_filter tests/config/clips_captions.toml)"
    echo "GOT='$got'"
    echo "EXP='$expected'"
    [ "$got" = "$expected" ]
}
