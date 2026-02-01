#!/bin/bash

source bin/make_gif

video=videos/HU2ftCitvyQ.mp4
hdr_video=tests/videos/sol_levante_hdr.mp4

@test segment_filter_original_empty {
    expected_filter=''
    expected_hash='d8ee0b0487c3'

    got="$(segment_filter tests/gifs/original.toml "$video")"
    diff -u <(echo "$expected_filter") <(echo "$got")

    hash="$(segment_hash tests/gifs/original.toml "$video")"
    diff -u <(echo "$expected_hash") <(echo "$hash")
}

@test segment_filter_fps_only {
    expected_filter='fps=10'
    expected_hash='6df436076b80'

    got="$(segment_filter tests/gifs/fps.toml "$video")"
    diff -u <(echo "$expected_filter") <(echo "$got")

    hash="$(segment_hash tests/gifs/fps.toml "$video")"
    diff -u <(echo "$expected_hash") <(echo "$hash")
}

@test segment_filter_fps_scale {
    expected_filter='fps=10,scale=480:-1'
    expected_hash='f13836af5fdb'

    got="$(segment_filter tests/gifs/scale.toml "$video")"
    diff -u <(echo "$expected_filter") <(echo "$got")

    hash="$(segment_hash tests/gifs/scale.toml "$video")"
    diff -u <(echo "$expected_hash") <(echo "$hash")
}

@test segment_filter_brighten {
    expected_filter='eq=brightness=0.25'
    expected_hash='79d44daa4be7'

    got="$(segment_filter tests/gifs/brighten.toml "$video")"
    diff -u <(echo "$expected_filter") <(echo "$got")

    hash="$(segment_hash tests/gifs/brighten.toml "$video")"
    diff -u <(echo "$expected_hash") <(echo "$hash")
}

@test segment_filter_denoise {
    expected_filter='hqdn3d'
    expected_hash='5095b2bc2cf8'

    got="$(segment_filter tests/gifs/denoise.toml "$video")"
    diff -u <(echo "$expected_filter") <(echo "$got")

    hash="$(segment_hash tests/gifs/denoise.toml "$video")"
    diff -u <(echo "$expected_hash") <(echo "$hash")
}

@test segment_filter_crop {
    expected_filter='fps=10,crop=200:100'
    expected_hash='37d464be690b'

    got="$(segment_filter tests/gifs/crop.toml "$video")"
    diff -u <(echo "$expected_filter") <(echo "$got")

    hash="$(segment_hash tests/gifs/crop.toml "$video")"
    diff -u <(echo "$expected_hash") <(echo "$hash")
}

@test segment_filter_clips {
    expected_filter='fps=16,crop=200:100,scale=320:-1'
    expected_hash='eddce40bd4cb'

    got="$(segment_filter tests/gifs/clips.toml "$video")"
    diff -u <(echo "$expected_filter") <(echo "$got")

    hash="$(segment_hash tests/gifs/clips.toml "$video")"
    diff -u <(echo "$expected_hash") <(echo "$hash")
}

@test segment_filter_combined_brighten {
    expected_filter='fps=16,crop=200:100,scale=320:-1,eq=brightness=0.25'
    expected_hash='675afe54a758'

    got="$(segment_filter tests/gifs/clips_brighten.toml "$video")"
    diff -u <(echo "$expected_filter") <(echo "$got")

    hash="$(segment_hash tests/gifs/clips_brighten.toml "$video")"
    diff -u <(echo "$expected_hash") <(echo "$hash")
}

@test segment_filter_combined_denoise {
    expected_filter='fps=16,crop=200:100,scale=320:-1,hqdn3d'
    expected_hash='a8902f0fd105'

    got="$(segment_filter tests/gifs/clips_denoise.toml "$video")"
    diff -u <(echo "$expected_filter") <(echo "$got")

    hash="$(segment_hash tests/gifs/clips_denoise.toml "$video")"
    diff -u <(echo "$expected_hash") <(echo "$hash")
}

@test segment_filter_captions {
    expected_filter='fps=18,scale=480:-1'
    expected_hash='ee7f173e46ec'

    got="$(segment_filter tests/gifs/captions.toml "$video")"
    diff -u <(echo "$expected_filter") <(echo "$got")

    hash="$(segment_hash tests/gifs/captions.toml "$video")"
    diff -u <(echo "$expected_hash") <(echo "$hash")
}

@test segment_filter_hdr_includes_tonemap {
    expected_filter='zscale=t=linear:npl=100,format=gbrpf32le,zscale=p=bt709,'
    expected_filter+='tonemap=hable:desat=0,zscale=t=bt709:m=bt709:r=tv,format=yuv420p,'
    expected_filter+='fps=12,scale=480:-1'
    expected_hash='4ab44f7cdb2b'

    got="$(segment_filter tests/gifs/sol-levante-hdr.toml "$hdr_video")"
    diff -u <(echo "$expected_filter") <(echo "$got")

    hash="$(segment_hash tests/gifs/sol-levante-hdr.toml "$hdr_video")"
    diff -u <(echo "$expected_hash") <(echo "$hash")
}
