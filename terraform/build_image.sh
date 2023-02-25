#!/bin/bash
#set -x

# Make the script file executable
#chmod +x 

# Clone the Git repository
git clone https://github.com/world-federation-of-advertisers/cross-media-measurement.git
cd cross-media-measurement

# Checkout to the desired commit
#git checkout 7fab61049e425bb0edd5fa2802290bf1722254e7
#cd ..

 # Build and push Docker images using Bazel

bazel query 'filter("push_kingdom", kind("container_push", //src/main/docker:all))' |
  xargs bazel build -c opt --define container_registry=gcr.io \
  --define image_repo_prefix=my-project-test-373810 --define image_tag=build-0004
  
      
bazel query 'filter("push_kingdom", kind("container_push", //src/main/docker:all))' |
  xargs -n 1 bazel run -c opt --define container_registry=gcr.io \
  --define image_repo_prefix=my-project-test-373810 --define image_tag=build-0002




sudo bazel query 'filter("push_kingdom", kind("container_push", //src/main/docker:all))' |
  xargs bazel build -c opt --define container_registry=gcr.io \
  --define image_repo_prefix=my-project-test-373810 --define image_tag=build-0004