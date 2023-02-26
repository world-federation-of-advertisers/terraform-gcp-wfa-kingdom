#!/bin/bash

install_git(){
  # Install Git and test git Installation
  sudo apt-get update
  sudo apt-get install -y git

  echo "Check GIT Installation"
  git --version
}

install_python3(){
  # Install Python
  apt-get install -y python3

  echo "Check Python Installation"
  python3 --version
}

install_clang(){
  # Install clang
  sudo apt-get install -y aptitude
  sudo aptitude install -y clang

  echo "Check clang Installation"
  clang --version
}

install_swig(){
  # Install swig
  sudo apt-get install -y swig

  echo "Check swig Installation"
  swig -version
}

install_jdk(){
  # Install JDK
  sudo apt-get install -y openjdk-11-jdk
  echo "JAVA_HOME=\"/usr/lib/jvm/java-11-openjdk-amd64\"" >> /etc/environment
  source /etc/environment

  echo "Check JDK Installation"
  java --version
}

install_kubectl(){

  # install kubectl
  curl -LO "https://dl.k8s.io/release/v1.26.0/bin/linux/amd64/kubectl"

  # Download the kubectl checksum file:
  curl -LO "https://dl.k8s.io/release/v1.26.0/bin/linux/amd64/kubectl.sha256"

  # Validate the kubectl binary against the checksum file:
  echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

  # Install kubectl
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

  echo "Check Kubectl Installation"
  kubectl
}

install_bazel(){
  # Install wget
  sudo apt-get install -y wget

  sudo wget https://github.com/bazelbuild/bazelisk/releases/download/v1.16.0/bazelisk-linux-amd64
  sudo chmod +x bazelisk-linux-amd64
  sudo mv bazelisk-linux-amd64 /usr/local/bin/bazelisk
}

clone_repo(){
  cd /tmp
  echo "Cloning the Repository"
  git clone -b main https://github.com/world-federation-of-advertisers/cross-media-measurement.git
  git clone -b main https://github.com/world-federation-of-advertisers/terraform-gcp-wfa-kingdom.git
}

bazel_build_and_push(){
  echo "Executing command to Build and push to GCR"
  sudo cp -rf /tmp/terraform-gcp-wfa-kingdom/terraform/build_image.sh /tmp/cross-media-measurement/build_image.sh
  sudo cp -rf /tmp/terraform-gcp-wfa-kingdom/terraform/push_image.sh /tmp/cross-media-measurement/push_image.sh
  cd /tmp/cross-media-measurement
  sudo chmod +x /tmp/cross-media-measurement/build_image.sh
  sudo chmod +x /tmp/cross-media-measurement/push_image.sh
  echo Y | sudo gcloud auth configure-docker

  echo "* * * * * cd /tmp/cross-media-measurement && sudo ./build_image.sh" | sudo crontab -
  echo "Waiting on crontab to be picked..."
  sleep 120
  logfile=$(sudo find /root/.cache/bazel/_bazel_root/ -name command.log)
  if [ $logfile != "" ]; then
    echo "Image build failed for some reason."
    return 127
  else
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
        completed=1
      fi
    done
  fi


}

{
  set -x && chmod +x

  sudo mkdir -p /tmp/logs

  printf "\n Starting the initialization script. \n"

  # Git Installation
  {
    printf "\n Installing Git..."
    install_git > /tmp/git_installation.log
    if [ $? -eq 0 ]; then
      echo "Git installed successfully."
    else
      echo "Git installation Failed with a return code $?"
      exit $?
    fi
    printf " Installation logs in /tmp/git_installation.log \n"
  }

  # Python Installation
  {
    printf "\n Installing Python..."
    install_python3 > /tmp/python_installation.log
    if [ $? -eq 0 ]; then
      echo "Python installed successfully."
    else
      echo "Python installation Failed with a return code $?"
      exit $?
    fi
    printf " Installation logs in /tmp/python_installation.log \n"
  }

  # Clang Installation
  {
    printf "\n Installing clang..."
    install_clang > /tmp/clang_installation.log
    if [ $? -eq 0 ]; then
      echo "clang installed successfully."
    else
      echo "clang installation Failed with a return code $?"
      exit $?
    fi
    printf " Installation logs in /tmp/clang_installation.log \n"
  }

  # Swig Installation
  {
    printf "\n Installing swig..."
    install_swig > /tmp/swig_installation.log
    if [ $? -eq 0 ]; then
      echo "swig installed successfully."
    else
      echo "swig installation Failed with a return code $?"
      exit $?
    fi
    printf " Installation logs in /tmp/swig_installation.log \n"
  }

  # JDK Installation
  {
    printf "\n Installing JDK..."
    install_jdk > /tmp/jdk_installation.log
    if [ $? -eq 0 ]; then
      echo "JDK installed successfully."
    else
      echo "JDK installation Failed with a return code $?"
      exit $?
    fi
    printf " Installation logs in /tmp/jdk_installation.log \n"
  }

  # Kubectl Installation
  {
    printf "\n Installing kubectl..."
    install_kubectl > /tmp/kubectl_installation.log
    if [ $? -eq 0 ]; then
      echo "kubectl installed successfully."
    else
      echo "kubectl installation Failed with a return code $?"
      exit $?
    fi
    printf " Installation logs in /tmp/kubectl_installation.log \n"
  }

  # Bazel Installation
  {
    printf "\n Installing bazel..."
    install_bazel > /tmp/bazel_installation.log
    if [ $? -eq 0 ]; then
      echo "Bazel installed successfully."
    else
      echo "Bazel installation Failed with a return code $?"
      exit $?
    fi
    printf " Installation logs in /tmp/bazel_installation.log \n"
  }

  # Clone application and Infra code
  {
    printf "\n Cloning repository cross-media-measurement..."
    clone_repo > /tmp/git_clone.log
    if [ $? -eq 0 ]; then
      echo "Cloned application code Successfully"
    else
      echo "git clone failed $?"
      exit $?
    fi
    printf " Clone logs in /tmp/git_clone.log \n"
  }

  # Bazel  build and Push
  {
    bazel_build_and_push > /tmp/build_and_push_image.log
    printf " Image creation Triggered in the background /tmp/build_image.log \n"

  }

  printf "\n Initialization Completed successfully \n\n "

} > /tmp/init_script.log