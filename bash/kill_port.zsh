#!/bin/zsh

# Usage: kill_port.sh <port>
# Example: ./kill_port.zsh 3000

if [ -z "$1" ]; then
  echo "Usage: $0 <port>"
  exit 1
fi

PORT="$1"
PIDS=$(lsof -i tcp:"$PORT" -t)

if [ -z "$PIDS" ]; then
  echo "No process is listening on port $PORT."
  exit 0
fi

echo "Killing process(es) on port $PORT: $PIDS"
kill $PIDS
