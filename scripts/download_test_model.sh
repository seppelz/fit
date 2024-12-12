#!/bin/bash

# Create models directory if it doesn't exist
mkdir -p assets/models

# Download a basic human model (we'll replace this with a better one later)
wget -O assets/models/human_model.glb https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/SimpleSparseAccessor/glTF-Binary/SimpleSparseAccessor.glb

# Make the script executable
chmod +x scripts/download_test_model.sh
