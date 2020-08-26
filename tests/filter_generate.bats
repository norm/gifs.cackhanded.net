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

@test generate_timing {
    expected='[0:v] scale=w=in_w:h=in_h [cv]; '
    expected+="[cv][2:v] overlay=(main_w-25):5:enable='between(t,0,0.25)' [tm0a];"
    expected+="[tm0a][2:v] overlay=(main_w-25):5:enable='between(t,0.5,0.75)' [tm0b];"
    expected+="[tm0b][2:v] overlay=(main_w-25):5:enable='between(t,1,1.25)' [tm1a];"
    expected+="[tm1a][2:v] overlay=(main_w-25):5:enable='between(t,1.5,1.75)' [tm1b];"
    expected+="[tm1b][2:v] overlay=(main_w-25):5:enable='between(t,2,2.25)' [tm2a];"
    expected+="[tm2a][2:v] overlay=(main_w-25):5:enable='between(t,2.5,2.75)' [tm2b];"
    expected+="[tm2b][2:v] overlay=(main_w-25):5:enable='between(t,3,3.25)' [tm3a];"
    expected+="[tm3a][2:v] overlay=(main_w-25):5:enable='between(t,3.5,3.75)' [tm3b];"
    expected+="[tm3b][2:v] overlay=(main_w-25):5:enable='between(t,4,4.25)' [tm4a];"
    expected+="[tm4a][2:v] overlay=(main_w-25):5:enable='between(t,4.5,4.75)' [tm4b];"
    expected+="[tm4b][2:v] overlay=(main_w-25):5:enable='between(t,5,5.25)' [tm5a];"
    expected+="[tm5a][2:v] overlay=(main_w-25):5:enable='between(t,5.5,5.75)' [tm5b];"
    expected+="[tm5b][2:v] overlay=(main_w-25):5:enable='between(t,6,6.25)' [tm6a];"
    expected+="[tm6a][2:v] overlay=(main_w-25):5:enable='between(t,6.5,6.75)' [tm6b];"
    expected+="[tm6b][2:v] overlay=(main_w-25):5:enable='between(t,7,7.25)' [tm7a];"
    expected+="[tm7a][2:v] overlay=(main_w-25):5:enable='between(t,7.5,7.75)' [tm7b];"
    expected+="[tm7b][2:v] overlay=(main_w-25):5:enable='between(t,8,8.25)' [tm8a];"
    expected+="[tm8a][2:v] overlay=(main_w-25):5:enable='between(t,8.5,8.75)' [tm8b];"
    expected+="[tm8b][2:v] overlay=(main_w-25):5:enable='between(t,9,9.25)' [tm9a];"
    expected+="[tm9a][2:v] overlay=(main_w-25):5:enable='between(t,9.5,9.75)' [tm9b];"
    expected+="[tm9b][2:v] overlay=(main_w-25):5:enable='between(t,10,10.25)' [tv];"
    expected+='[tv][1:v] paletteuse='
    expected+='dither=bayer:bayer_scale=4:diff_mode=rectangle'

    got="$(generate_filter tests/config/timing.toml)"
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
    expected+='[iv][3:v] overlay=(main_w-overlay_w):(main_h-overlay_h)'
    expected+=":enable='between(t,0,0.3)' [v1]; "
    expected+='[v1][4:v] overlay=(main_w-overlay_w):(main_h-overlay_h)'
    expected+=":enable='between(t,0.31,0.6)' [v2]; "
    expected+='[v2][5:v] overlay=(main_w-overlay_w):(main_h-overlay_h)'
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
    expected+='[iv][3:v] overlay=(main_w-overlay_w):(main_h-overlay_h)'
    expected+=":enable='between(t,0,0.5)' [v1]; "
    expected+='[v1][4:v] overlay=(main_w-overlay_w):(main_h-overlay_h)'
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
    expected+='[cv][3:v] overlay=(main_w-overlay_w):(main_h-overlay_h)'
    expected+=":enable='between(t,0,0.3)' [v1]; "
    expected+='[v1][4:v] overlay=(main_w-overlay_w):(main_h-overlay_h)'
    expected+=":enable='between(t,0.31,0.6)' [v2]; "
    expected+='[v2][5:v] overlay=(main_w-overlay_w):(main_h-overlay_h)'
    expected+=":enable='between(t,0.61,0.9)' [v3]; "
    expected+='[v3][1:v] paletteuse='
    expected+='dither=bayer:bayer_scale=4:diff_mode=rectangle'

    got="$(generate_filter tests/config/clips_captions.toml)"
    echo "GOT='$got'"
    echo "EXP='$expected'"
    [ "$got" = "$expected" ]
}

@test generate_clips_captions_timing {
    expected='[0:v] fps=18,trim=start=10:end=12,setpts=PTS-STARTPTS [c1]; '
    expected+='[0:v] fps=18,trim=start=70:end=72,setpts=PTS-STARTPTS [c2]; '
    expected+='[c1][c2] concat=n=2:v=1,scale=480:-1 [cv];'
    expected+="[cv][2:v] overlay=(main_w-25):5:enable='between(t,0,0.25)' [tm0a];"
    expected+="[tm0a][2:v] overlay=(main_w-25):5:enable='between(t,0.5,0.75)' [tm0b];"
    expected+="[tm0b][2:v] overlay=(main_w-25):5:enable='between(t,1,1.25)' [tm1a];"
    expected+="[tm1a][2:v] overlay=(main_w-25):5:enable='between(t,1.5,1.75)' [tm1b];"
    expected+="[tm1b][2:v] overlay=(main_w-25):5:enable='between(t,2,2.25)' [tm2a];"
    expected+="[tm2a][2:v] overlay=(main_w-25):5:enable='between(t,2.5,2.75)' [tm2b];"
    expected+="[tm2b][2:v] overlay=(main_w-25):5:enable='between(t,3,3.25)' [tm3a];"
    expected+="[tm3a][2:v] overlay=(main_w-25):5:enable='between(t,3.5,3.75)' [tm3b];"
    expected+="[tm3b][2:v] overlay=(main_w-25):5:enable='between(t,4,4.25)' [tm4a];"
    expected+="[tm4a][2:v] overlay=(main_w-25):5:enable='between(t,4.5,4.75)' [tm4b];"
    expected+="[tm4b][2:v] overlay=(main_w-25):5:enable='between(t,5,5.25)' [tm5a];"
    expected+="[tm5a][2:v] overlay=(main_w-25):5:enable='between(t,5.5,5.75)' [tm5b];"
    expected+="[tm5b][2:v] overlay=(main_w-25):5:enable='between(t,6,6.25)' [tm6a];"
    expected+="[tm6a][2:v] overlay=(main_w-25):5:enable='between(t,6.5,6.75)' [tm6b];"
    expected+="[tm6b][2:v] overlay=(main_w-25):5:enable='between(t,7,7.25)' [tm7a];"
    expected+="[tm7a][2:v] overlay=(main_w-25):5:enable='between(t,7.5,7.75)' [tm7b];"
    expected+="[tm7b][2:v] overlay=(main_w-25):5:enable='between(t,8,8.25)' [tm8a];"
    expected+="[tm8a][2:v] overlay=(main_w-25):5:enable='between(t,8.5,8.75)' [tm8b];"
    expected+="[tm8b][2:v] overlay=(main_w-25):5:enable='between(t,9,9.25)' [tm9a];"
    expected+="[tm9a][2:v] overlay=(main_w-25):5:enable='between(t,9.5,9.75)' [tm9b];"
    expected+="[tm9b][2:v] overlay=(main_w-25):5:enable='between(t,10,10.25)' [tv];"
    expected+='[tv][3:v] overlay=(main_w-overlay_w):(main_h-overlay_h)'
    expected+=":enable='between(t,0,0.3)' [v1]; "
    expected+='[v1][4:v] overlay=(main_w-overlay_w):(main_h-overlay_h)'
    expected+=":enable='between(t,0.31,0.6)' [v2]; "
    expected+='[v2][5:v] overlay=(main_w-overlay_w):(main_h-overlay_h)'
    expected+=":enable='between(t,0.61,0.9)' [v3]; "
    expected+='[v3][1:v] paletteuse='
    expected+='dither=bayer:bayer_scale=4:diff_mode=rectangle'

    got="$(generate_filter tests/config/clips_captions_timing.toml)"
    echo "GOT='$got'"
    echo "EXP='$expected'"
    [ "$got" = "$expected" ]
}
