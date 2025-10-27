#!/bin/bash

# Set the path to your desktop
DESKTOP_PATH="$HOME/Desktop"

# Iterate over each item in the Desktop directory
for dir in "$DESKTOP_PATH"/*; do
  # Check if it's a directory
  if [ -d "$dir" ]; then
    # Change to the directory
    cd "$dir" || continue
    
    # Check if the directory is a Git repository
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
      echo "Running gitup in $dir"
      git add -A && git commit -m "backup" && git push
      echo "-----------------------------------"
    fi
  fi
done

cd ~/Documents
echo "Running git status in $PWD"
git add -A && git commit -m "backup" && git push
echo "-----------------------------------"

cd ~/dotfiles
echo "Running git status in $PWD"
git add -A && git commit -m "backup" && git push
echo "-----------------------------------"
