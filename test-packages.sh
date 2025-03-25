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



URL="https://raw.githubusercontent.com/enriicola/dotfiles/main/packages.txt"

FILE_CONTENT=$(curl -s "$URL")

# Check if the download was successful
if [[ $? -ne 0 ]]; then
   echo "Failed to download the file."
   exit 1
fi

# Iterate over each line in the downloaded content
echo "Contents of the file:"
for LINE in ${(f)FILE_CONTENT}; do
   echo "$LINE"
done