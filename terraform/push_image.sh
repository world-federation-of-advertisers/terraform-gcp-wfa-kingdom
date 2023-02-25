#!/bin/bash
set -x && chmod +x

cd /tmp/cross-media-measurement

echo "Executing command to Push the built image to GCR"
bazelisk query 'filter("push_kingdom", kind("container_push", //src/main/docker:all))' | \
  xargs -n 1 bazelisk run -c opt --define container_registry=gcr.io \
  --define image_repo_prefix=my-project-test-373810 --define image_tag=build-0004