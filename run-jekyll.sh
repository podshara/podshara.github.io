#!/bin/bash
set -e  # Exit on error

cd "$(dirname "$0")"

# Detect Ruby version dynamically
RUBY_VERSION=$(ruby -e "puts RUBY_VERSION" 2>/dev/null || echo "3.4.0")
RUBY_VERSION_SHORT=$(echo "$RUBY_VERSION" | cut -d. -f1,2)

# Set up vendor bundle paths
VENDOR_BUNDLE="$(pwd)/vendor/bundle"
GEM_HOME="${VENDOR_BUNDLE}/ruby/${RUBY_VERSION_SHORT}"
export GEM_HOME
export GEM_PATH="$GEM_HOME"
export PATH="${GEM_HOME}/bin:$PATH"
export BUNDLE_PATH="$VENDOR_BUNDLE"

# Prevent loading the problematic system Ruby defaults file
export RUBYLIB=""
unset RUBYOPT

# Check if bundle is available
if ! command -v bundle >/dev/null 2>&1; then
    echo "Error: bundle command not found. Please install bundler first."
    echo "Run: gem install bundler"
    exit 1
fi

# Install dependencies if needed
if [ ! -d "$VENDOR_BUNDLE" ] || [ ! -f "$VENDOR_BUNDLE/.bundle/config" ]; then
    echo "Installing Jekyll dependencies..."
    bundle install
fi

# Run Jekyll
bundle exec jekyll serve -l -H localhost --port 4000 "$@"

