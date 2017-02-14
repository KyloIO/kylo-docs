#!/bin/bash

echo "Deleting the build folder"
rm -rf _build

echo "Rebuilding all docs"
make html
