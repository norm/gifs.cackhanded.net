Create JSON that GIFwrapped can consume to improve the custom search.

```json example.json
{
    "publish_date": "2020-08-01T07:00:00Z",
    "colors": 70,
    "file_size": 1470000,
    "frames": 82,
    "duration": 6.83,
    "width": 480,
    "height": 285,
    "tags": ["mazzgif", "stitch", "captain-gantu"],
    "caption": "Captain Gantu tries to punch Stitch...",
    "source": "Lilo & Stitch",
    "images": {
        "original": "https://gifs.cackhanded.net/lilo-and-stitch/also-cute-and-fluffy.gif",
        "thumbnail": "https://gifs.cackhanded.net/lilo-and-stitch/also-cute-and-fluffy.tn.gif"
    },
    "url": "https://gifs.cackhanded.net/lilo-and-stitch/also-cute-and-fluffy",
}
```

- [ ] generate JSON alongside the HTML with a pure data representation

```json index.json
[
    {"tag": "lilo-and-stitch", "publish_date": "2020-08-01", "url": "..."},
    {"tag": "mazzgif", "publish_date": "2020-08-01", "url": "..."},
    {"tag": "stitch", "publish_date": "2020-08-01", "url": "..."},
    {"tag": "captain-gantu", "publish_date": "2020-08-01", "url": "..."}
]
```

- [ ] generate an index.json at the site root which contains keys and URLs,
      blending tags, titles, and sources
