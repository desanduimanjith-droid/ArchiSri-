#!/bin/bash

# Constructor Connect Backend - Run Script
# This script automatically activates the virtual environment and starts the backend

cd "$(dirname "$0")" || exit

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "❌ Virtual environment not found!"
    echo "Creating virtual environment..."
    python3 -m venv venv
    echo "Installing dependencies..."
    ./venv/bin/pip install -r requirements.txt
fi

# Activate virtual environment and run the app
echo "🚀 Starting Constructor Connect Backend..."
echo "📍 Server will be available at http://localhost:8000"
echo ""

./venv/bin/python3 app.py
