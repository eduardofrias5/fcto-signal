#!/bin/bash
set -e

# Read current version from index.html
CURRENT=$(grep -o 'v[0-9]\+\.[0-9]\+' index.html | head -1)
MAJOR=$(echo "$CURRENT" | cut -d. -f1 | tr -d 'v')
MINOR=$(echo "$CURRENT" | cut -d. -f2)
NEXT_MINOR=$((MINOR + 1))
NEXT="v${MAJOR}.${NEXT_MINOR}"

# Update version in file
sed -i '' "s/${CURRENT}/${NEXT}/g" index.html

echo "Version: ${CURRENT} → ${NEXT}"

# Deploy to Quick
quick deploy . fcto-signal --force

# Commit and push to GitHub
git add index.html
git commit -m "Release ${NEXT}"
git push origin main

echo "GitHub: pushed ${NEXT} to origin/main"
