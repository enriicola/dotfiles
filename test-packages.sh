#!/bin/zsh

# # Check if packages.txt file exists
# if [[ ! -f "packages.txt" ]]; then
#    echo "Error: packages.txt file not found"
#    exit 1
# fi

# # Read packages from file and install them
# while read package; do
#    # Skip empty lines and comments
#    if [[ -z "$package" || "$package" == \#* ]]; then
#       continue
#    fi
   
#    echo "Installing $package..."
#    # sudo apt-get install -y "$package"
# done < packages.txt

# echo "All packages have been installed!"

# Download packages.txt from GitHub and install packages
curl https://raw.githubusercontent.com/enriicola/dotfiles/refs/heads/main/packages.txt | while read package; do
   # Skip empty lines and comments
   if [[ -z "$package" || "$package" == \#* ]]; then
      continue
   fi
   
   echo "Installing $package..."
   # sudo apt-get install -y "$package"
done

echo "All packages have been installed!"