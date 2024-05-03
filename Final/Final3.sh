#!/bin/bash

# Check if the report.txt file exists
if [ ! -f report.txt ]; then
    echo "report.txt not found!"
    exit 1
fi

# Create a new HTML file
echo "<html>" > report.html
echo "<body>" >> report.html
echo "<table border='1'>" >> report.html

# Convert the report.txt file to HTML
awk 'BEGIN {FS=","; print "<tr><th>IP</th><th>Date/Time</th><th>Page Accessed</th></tr>"}
     {print "<tr><td>"$1"</td><td>"$2"</td><td>"$3"</td></tr>"}' report.txt >> report.html

echo "</table>" >> report.html
echo "</body>" >> report.html
echo "</html>" >> report.html

# Move the HTML report to the /var/www/html/ directory
mv report.html /var/www/html/