#!/bin/zsh

# This script pushes your Speed Reader Flutter app to GitHub
# Run this script after creating the repository on GitHub as described in GITHUB_REPO_SETUP.md

echo "🚀 Pushing Speed Reader Flutter app to GitHub..."
git remote add origin https://github.com/chkarip/speed-reader.git
git push -u origin main

# Check if push was successful
if [ $? -eq 0 ]; then
  echo "✅ Success! Your Speed Reader app is now on GitHub!"
  echo "📊 Repository URL: https://github.com/chkarip/speed-reader"
else
  echo "❌ Push failed. Please check your GitHub authentication."
  echo "ℹ️  See GITHUB_AUTH_SETUP.md for authentication help."
fi
