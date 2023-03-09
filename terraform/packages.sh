#!/bin/bash

bazel_build(){
  echo "Executing command to Build artifact"
  sudo cp -rf /tmp/terraform-gcp-wfa-kingdom/terraform/build_image.sh /tmp/cross-media-measurement/build_image.sh
  sudo cp -rf /tmp/terraform-gcp-wfa-kingdom/terraform/push_image.sh /tmp/cross-media-measurement/push_image.sh
  cd /tmp/cross-media-measurement
  sudo chmod +x /tmp/cross-media-measurement/build_image.sh
  sudo chmod +x /tmp/cross-media-measurement/push_image.sh
  echo "* * * * * cd /tmp/cross-media-measurement && sudo ./build_image.sh" | sudo crontab -
  echo "Waiting on crontab to be picked..."
  sleep 120
  logfile=$(sudo find /root/.cache/bazel/_bazel_root/ -name command.log)
  echo "The Log file for the Bazel command is $logfile"
  if [ "$logfile" == "" ]; then
    echo "Image build failed for some reason."
    return 127
  fi
  echo "Detailed Logs can be found in $logfile"
  until completed
  do
    sudo grep "Build completed successfully," $logfile
    if [ $? -ne 0 ]; then
      date
      echo "$(date) - $(tail -1 $logfile)"
      echo "Sleeping for 1 minute... check again in 1 minutes."
      sleep 60
      continue
    else
      echo "Completed Image Build Successfully"
      completed=0
      break
    fi
  done
}

bazel_push(){
  echo "Executing command to push to GCR"
  sleep 30
  echo "* * * * * cd /tmp/cross-media-measurement && sudo ./push_image.sh" | sudo crontab -
}


{
  set -x && chmod +x

  sudo mkdir -p /tmp/logs

  printf "\n Starting the initialization script. \n"

  # Bazel build
  {
    printf " Image creation Triggered in the background /tmp/build_image.log \n"
    bazel_build > /tmp/build_image.log
    printf " Quite Likely completed. \n\n"
  }

  # Bazel Push
  {
    Printf " Consolidating results to Push the Image..."
    bazel_push > /tmp/push_image.log
    printf " Quite Likely push completed. \n"
  }

  printf "\n Initialization Completed successfully \n\n "

} > /tmp/init_script.log