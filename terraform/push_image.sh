#!/bin/bash
set -x && chmod +x
sudo crontab -r

cd /tmp/cross-media-measurement

echo "[core]" > /root/.config/gcloud/configurations/config_default
echo "account = mohanraj.dharmalingam@zealsols.com" >> /root/.config/gcloud/configurations/config_default
echo "project = halo-cmm-sandbox" >>  /root/.config/gcloud/configurations/config_default
sudo gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://eu.gcr.io

echo "Executing command to Push the built image to GCR"
echo Y | sudo gcloud auth configure-docker
sudo bazelisk query 'filter("push_kingdom", kind("container_push", //src/main/docker:all))' | \
  xargs -n 1 bazelisk run -c opt --define container_registry=gcr.io \
  --define image_repo_prefix=halo-cmm-sandbox --define image_tag=build-0004 > push_image.log