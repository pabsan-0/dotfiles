#!/bin/bash
# Usage: wtree <git-url>

REPO_URL=$1
TARGET_DIR="$(basename -s .git "$REPO_URL").wt"

if [ -z "$REPO_URL" ]; then
    echo "Usage: $(basename "$0") <repo-url>"
    exit 1
fi

if [ -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' already exists."
    exit 1
fi
mkdir -p "$TARGET_DIR" || { echo "Error: Failed to create directory '$TARGET_DIR'"; exit 1; }
cd "$TARGET_DIR"       || { echo "Error: Failed to enter directory '$TARGET_DIR'"; exit 1; }


if ! git clone --bare "$REPO_URL" .bare; then
    echo "Error: Failed to clone repository."
    cd ..
    rm -rf "$TARGET_DIR"
    exit 1
fi

echo "gitdir: ./.bare" > .git
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git fetch --all

DEFAULT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
git worktree add "$DEFAULT_BRANCH"
