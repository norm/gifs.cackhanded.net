HDR sources appear washed out without tone mapping.
Requires ffmpeg with zimg support.

```bash
brew tap homebrew-ffmpeg/ffmpeg
brew install homebrew-ffmpeg/ffmpeg/ffmpeg --with-zimg
```

Possible tonemap filter:

```
zscale=t=linear:npl=100,format=gbrpf32le,zscale=p=bt709,tonemap=hable:desat=0,zscale=t=bt709:m=bt709:r=tv,format=yuv420p
```

CC-licensed HDR sample videos that could be added to the test suite:

- [Jellyfin Test Videos](https://repo.jellyfin.org/test-videos/) - CC Attribution-Sharealike, organised by type including HDR10
- [Prolost HDR Samples](https://prolost.gumroad.com/l/hdrsample) - Free, HLG and BT.2020 samples
- [Openfootage](https://www.openfootage.net/) - Various CC-licensed footage including HDR

- [X] detect markers (`smpte2084`, `bt2020`) in ffprobe output
- [X] add tonemap filter to the palette chooser
- [X] add tonemap filter to the image processing
- [X] add sample HDR GIF to `compare.bats`

The actual test sample used `tests/videos/sol_levante_hdr.mp4` is a 10-second
clip extracted from [Sol Levante](https://opencontent.netflix.com/):

```bash
ffmpeg \
    -y \
    -ss 00:56 \
    -i SolLevante_HDR10_r2020_ST2084_UHD_24fps_1000nit.mov \
    -t 10 \
    -vf "scale=1920:1080" \
    -c:v libx265 \
    -crf 22 \
    -preset medium \
    -pix_fmt yuv420p10le \
    -color_primaries bt2020 \
    -color_trc smpte2084 \
    -colorspace bt2020nc \
    -x265-params "hdr-opt=1:repeat-headers=1:colorprim=bt2020:transfer=smpte2084:colormatrix=bt2020nc" \
    -tag:v hvc1 \
    -an \
    tests/videos/sol_levante_hdr.mp4
```
