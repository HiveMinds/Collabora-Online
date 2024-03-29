#!/usr/bin/env bash

# Usage: ensure_pip_pkg <PKG> <pip_UPDATE>
# Takes the name of a package to install if not already installed,
# and optionally a 1 if pip update should be run after installation
# has finished.
ensure_pip_pkg() {
  local pip_package_name="$1"
  local execute_pip_update="$2"

  # Determine if pip package is installed or not.
  local pip_pckg_exists
  pip_pckg_exists=$(
    pip list | grep -F "$pip_package_name"
    echo $?
  )

  # Install pip package if pip package is not yet installed.
  if [ "$pip_pckg_exists" == "1" ]; then
    printf "==========================\\n"
    red_msg " ${pip_package_name} is not installed. Installing now.\\n"
    printf "==========================\\n\\n"
    pip install "${pip_package_name}"
  else
    printf "======================\\n"
    green_msg " ${pip_package_name} is installed\\n"
    printf "======================\\n"
  fi

  verify_pip_installed "${pip_package_name}"

  if [ "$execute_pip_update" == "1" ]; then
    printf "======================\\n"
    green_msg "Performing pip update\\n"
    printf "======================\\n"
    #pipenv update
  fi
}

# Verifies pip package is installed.
verify_pip_installed() {
  local pip_package_name="$1"

  # Determine if pip package is installed or not.
  local pip_pckg_exists
  pip_pckg_exists=$(
    pip list | grep -F "$pip_package_name"
    echo $?
  )

  # Throw error if pip package is not yet installed.
  if [ "$pip_pckg_exists" == "1" ]; then
    printf "==========================\\n"
    red_msg "Error, the pip package ${pip_package_name} is not installed.\\n"
    printf "==========================\\n\\n"
    exit 3 # TODO: update exit status.
  else
    printf "======================\\n"
    green_msg "Verified pip package ${pip_package_name} is installed.\\n"
    printf "======================\\n"
  fi
}
