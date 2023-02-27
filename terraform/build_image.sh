#!/bin/bash
set -x && chmod +x
sudo crontab -r

cd /tmp/cross-media-measurement

echo "Executing command to Build"
sudo bazelisk query 'filter("push_kingdom", kind("container_push", //src/main/docker:all))' | \
  xargs bazelisk build -c opt --define container_registry=gcr.io \
  --define image_repo_prefix=halo-cmm-sandbox --define image_tag=build-0004