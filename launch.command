#!/bin/bash
# Automatically navigate to the directory where this script is saved
cd "$(dirname "$0")"

# Execute your bulletproof environment command
.venv/bin/streamlit run app.py
