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

- [ ] detect markers (`smpte2084`, `bt2020`) in ffprobe output
- [ ] add tonemap filter to the palette chooser
- [ ] add tonemap filter to the image processing
- [ ] add sample HDR GIF to `compare.bats`
