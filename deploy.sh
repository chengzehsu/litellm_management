#!/bin/bash

# Deployment Script for LiteLLM + Langfuse Integration
# This script helps you deploy to GitHub and Zeabur

set -e

echo "🚀 LiteLLM + Langfuse Deployment Helper"
echo "========================================"
echo ""

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "❌ Git repository not initialized"
    echo "Run: git init"
    exit 1
fi

# Check current branch
CURRENT_BRANCH=$(git branch --show-current)
echo "📍 Current branch: $CURRENT_BRANCH"
echo ""

# Check if remote is set
if ! git remote | grep -q origin; then
    echo "⚠️  No GitHub remote configured"
    echo ""
    echo "To connect to GitHub:"
    echo "1. Create a new repository on GitHub"
    echo "2. Run the following command:"
    echo ""
    echo "   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
    echo ""
    echo "Or if you already have a repository URL:"
    read -p "Enter your GitHub repository URL: " REPO_URL
    if [ ! -z "$REPO_URL" ]; then
        git remote add origin "$REPO_URL"
        echo "✅ Remote added: $REPO_URL"
    else
        echo "❌ No repository URL provided"
        exit 1
    fi
else
    REMOTE_URL=$(git remote get-url origin)
    echo "✅ Remote configured: $REMOTE_URL"
fi

echo ""
echo "📋 Next steps:"
echo "=============="
echo ""
echo "1. Push to GitHub:"
echo "   git push -u origin $CURRENT_BRANCH"
echo ""
echo "2. Set up Zeabur:"
echo "   a. Go to https://zeabur.com"
echo "   b. Create a new project or open existing project"
echo "   c. Click 'Add Service' → 'Import from GitHub'"
echo "   d. Select your repository"
echo "   e. Zeabur will auto-detect Dockerfile"
echo ""
echo "3. Configure environment variables in Zeabur:"
echo "   - LITELLM_MASTER_KEY"
echo "   - DATABASE_URL"
echo "   - LANGFUSE_PUBLIC_KEY"
echo "   - LANGFUSE_SECRET_KEY"
echo "   - DISABLE_ADMIN_UI=True"
echo "   - (and any LLM provider API keys)"
echo ""
echo "4. Enable auto-deploy in Zeabur service settings"
echo ""
echo "5. After pushing, check:"
echo "   - GitHub Actions: https://github.com/YOUR_USERNAME/YOUR_REPO/actions"
echo "   - Zeabur Dashboard: https://zeabur.com"
echo ""

# Ask if user wants to push now
read -p "Do you want to push to GitHub now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Pushing to GitHub..."
    git push -u origin "$CURRENT_BRANCH"
    echo ""
    echo "✅ Code pushed to GitHub!"
    echo "📦 GitHub Actions will run automatically"
    echo "🔗 Check: https://github.com/$(git remote get-url origin | sed 's/.*github.com[:/]\(.*\)\.git/\1/')/actions"
else
    echo "You can push later with: git push -u origin $CURRENT_BRANCH"
fi

