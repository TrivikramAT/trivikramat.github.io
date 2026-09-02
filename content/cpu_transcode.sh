#!/bin/bash

for vid in *.mp4; do
  [ -f "$vid" ] || continue
  [[ "$vid" == *"_opt.mp4"* ]] && continue

  base="${vid%.*}"

  echo "=========================================="
  echo "CPU Software Processing (Sanity Check): $vid"
  echo "=========================================="

  # 1. WebM VP9 (CPU Software)
  echo "--> Encoding WebM with libvpx-vp9 (CPU)..."
  ffmpeg -hide_banner -loglevel warning -y \
    -i "$vid" \
    -c:v libvpx-vp9 -crf 20 -b:v 0 \
    -c:a libopus -b:a 128k "${base}_opt.webm"

  # 2. H.265 MP4 (CPU Software)
  echo "--> Encoding H.265 MP4 with libx265 (CPU)..."
  ffmpeg -hide_banner -loglevel warning -y \
    -i "$vid" \
    -c:v libx265 -crf 18 -preset medium \
    -tag:v hvc1 -movflags +faststart \
    -c:a aac -b:a 128k "${base}_opt.mp4"

  echo "Finished $vid"
done