#!/usr/bin/env fish

for f in *.svg
    set out (path change-extension png $f)
    magick $f $out
    pngquant -f --output $out $out
end

