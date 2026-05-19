#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing Claude Code config..."

# Create directories
mkdir -p "$HOME/.claude/hooks"
mkdir -p "$HOME/.claude/plugins"
mkdir -p "$HOME/.agents/skills"

# Copy main config files
cp "$SCRIPT_DIR/CLAUDE.md" "$HOME/.claude/"
cp "$SCRIPT_DIR/settings.json" "$HOME/.claude/"

# Copy hooks
cp "$SCRIPT_DIR/hooks/"* "$HOME/.claude/hooks/"

# Copy plugins manifest
cp "$SCRIPT_DIR/plugins/installed_plugins.json" "$HOME/.claude/plugins/"

# Copy skills
cp -r "$SCRIPT_DIR/skills/"* "$HOME/.agents/skills/"

# Create symlinks in ~/.claude/skills/
mkdir -p "$HOME/.claude/skills"
for skill in "$HOME/.agents/skills/"*/; do
    name=$(basename "$skill")
    ln -sf "../../.agents/skills/$name" "$HOME/.claude/skills/$name"
done

echo "Done. Restart Claude Code to apply."
