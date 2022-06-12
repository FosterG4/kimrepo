find . -type f \( -iname ".jpg" -o -iname ".jpeg" \) -exec jpegoptim -f -m75 --strip-all {} \;


find . \( -iname '*.jpg' -o -iname '*.jpeg' \) -print0 | \
  xargs -I@ -0 -n 1 -P 4 sh -c 'jpegoptim --max=75 -s "@" || exit 0'

#!/bin/bash
find . \( -iname '*.jpg' -o -iname '*.jpeg' \) -print0 | \
xargs -I@ -0 -n 1 -P 4 sh -c 'jpegoptim --max=75 -s "@" || exit 0'