#!/bin/bash

# ==============================================
# AI Context Linker Script
# ==============================================
# This script establishes AGENTS.md as the single source of truth
# by creating symbolic links for various AI tools that expect
# different filenames.
#
# It must be run from the project root where AGENTS.md resides.
# ==============================================

SOURCE_FILE="AGENTS.md"

# 1. Ensure the source file exists before proceeding.
if [ ! -f "$SOURCE_FILE" ]; then
    echo "Error: $SOURCE_FILE not found in current directory."
    echo "Please ensure you are in the project root and the file exists."
    exit 1
fi

echo "Creating symbolic links..."
echo "---"

# Function to create a link and report status
create_link() {
    local target_file=$1
    local link_name=$2
    # -s: symbolic link
    # -f: force (overwrite existing link if necessary)
    ln -sf "$target_file" "$link_name"
    echo "🔗 Linked: $link_name -> $target_file"
}

# --- Link Definitions ---

# 1. Cursor IDE (.cursorrules)
# Cursor reads AGENTS.md, but .cursorrules is still its native preference.
create_link "$SOURCE_FILE" ".cursorrules"

# 2. Claude Code (CLAUDE.md)
# As of late 2025, Claude CLI specifically looks for this file.
create_link "$SOURCE_FILE" "CLAUDE.md"

# --- End Definitions ---

echo "---"
echo "Success! All AI tools are now synced to $SOURCE_FILE."
