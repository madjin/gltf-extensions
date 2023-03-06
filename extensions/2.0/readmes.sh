#!/bin/bash

for folder in $(ls -d */ | sed 's#/##g');do
  cd $folder
  pandoc README.md -f gfm+pipe_tables -t html -s -o $folder.html --css ../table2.css
  wkhtmltoimage --width 0 $folder.html $folder.jpg
  
  # Get image height
  height=$(identify -format "%h" $folder.jpg)
  
  if [ $height -gt 32000 ]; then
    crop="1x8"
    tile="8x"
  elif [ $height -gt 16000 ]; then
    crop="1x6"
    tile="6x"
  elif [ $height -gt 4096 ]; then
    crop="1x3"
    tile="3x"
  elif [ $height -gt 2048 ]; then
    crop="1x2"
    tile="2x"
  else
    crop="1x1"
    tile="1x"
  fi
  
  convert -density 150 -quality 90 $folder.jpg -crop $crop@ +repage +adjoin long-site-%03d.jpg
  montage long-site-*.jpg -geometry +0+0 -tile $tile -quality 90 poster_$folder.jpg
  rm long-site*.jpg
  rm $folder.jpg
  cd ../
done
