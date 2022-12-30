#!/bin/bash
get_tor_status() {
  tor_status=$(curl --socks5 localhost:9050 --socks5-hostname localhost:9050 -s https://check.torproject.org/ | cat | grep -m 1 Congratulations | xargs)
  echo "$tor_status"
}

connect_tor() {
  tor_connection=$(nohup sudo tor >sudo_tor.out &)
  sleep 10 3>- &
  echo "$tor_connection"
}

start_and_monitor_tor_connection() {
  # TODO: verify the tor script and sites have been deployed before proceeding, send message otherwise

  # Start infinite loop that keeps system connected to tor
  while true; do
    # Get tor connection status
    tor_status_outside=$(get_tor_status)
    echo "tor_status_outside=$tor_status_outside" >&2
    sleep 10

    # Reconnect tor if the system is disconnected.
    if [[ "$tor_status_outside" != *"Congratulations"* ]]; then
      echo "Is Disconnected"

      # Stop all previous tor processes.
      sudo killall tor
      sleep 10

      # Create new tor connection.
      connect_tor
    elif [[ "$tor_status_outside" == *"Congratulations"* ]]; then
      echo "Is connected"
    fi
  done
}