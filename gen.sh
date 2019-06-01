#! /bin/bash

# Write to this file
OUT=docs/index.html

cat << EOF > $OUT
<!doctype html>
<html lang = 'en'>
<head>
<meta charset = 'utf-8'>
<meta name = 'viewport' content = 'width=device-width, initial-scale=1.0'>
<meta name = 'description' content = 'Resume for Michael DeFelice - a Data Scientist, Developer, and Infrastructure Architect with 15 years of experience and an expertise in machine learning & AI.'>
<title>Michael DeFelice</title>
</head>
<body>
<pre style = 'white-space: pre-wrap;'>
EOF

cat cv-defelice_2019.txt >> $OUT

cat << EOF >> $OUT
</pre>
</body>
</html>
EOF
