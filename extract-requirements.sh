#!/bin/sh

# extract requirements.txt from ipynb files
#
# Depends on: 
# pip install -U ipynb-py-convert pipreqs
# and ripgrep
#
# note: versions are specific to what is installed locally at
#       the time of running pipreqs

# make local temporary directories for processing
mkdir -p ./tmp/imports ./tmp/python

# convert *.ipynb notebooks to *.py scripts
for file in *.ipynb; do ipynb-py-convert $file tmp/python/$file.py; done

# extract import statements
rg -I -N --no-heading '^import' python/*.py > tmp/imports/temp.py
rg -I -N --no-heading '^from ' python/*.py >> tmp/imports/temp.py

# produce requirements.txt file from extracted import statements
# note: this may result in an error if there are non-standard import
#       statements in any of the *.py files produced by ipynb-py-convert
pipreqs ./tmp/imports/

# copy requirements.txt to local directory
cp tmp/imports/requirements.txt .

# cleanup
rm -r tmp