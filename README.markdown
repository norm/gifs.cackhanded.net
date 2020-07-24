gifs.cackhanded.net
===================

Source files for generating http://gifs.cackhanded.net


## Making a GIF from a video

The GIFs are made from video sources using ffmpeg, following this guide:
https://engineering.giphy.com/how-to-make-gifs-with-ffmpeg/

The output quality is improved with a global palette and dithering, using tips
from this guide: http://blog.pkh.me/p/21-high-quality-gif-with-ffmpeg.html

The file size is then reduced using gifsicle.
