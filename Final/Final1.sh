#!/bin/bash

# URL of the webpage
url="10.0.17.5/IOC.html"

# Download the webpage
curl $url > webpage.txt

# Extract IOCs (replace 'PATTERN' with the actual pattern of the IOCs)
grep -E 'cmd=|1=1#|etc/passwd|/bin/bash|/bin/sh|1=1--+' webpage.txt > IOC.txt

# Remove the downloaded webpage
rm webpage.txt