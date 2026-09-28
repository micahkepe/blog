# Content Notes

## Tools

Compress videos with `ffmpeg` for GIFs:

```bash
ffmpeg -i video.mp4 -vcodec libx264 -crf 28 -preset slow -an video-cmp.mp4
```
