#! /bin/bash

# Write to this file
OUT=index.html

cat << EOF > $OUT
<!doctype html>
<html lang = 'en'>
<head>
<meta charset = 'utf-8'>
<meta name = 'viewport' content = 'width=device-width, initial-scale=1.0'>
<meta name = 'description' content = 'Resume for Michael DeFelice - a Data Scientist, Developer, and Infrastructure Architect with 15 years of experience and an expertise in machine learning & AI.'>
<script type = 'application/ld+json'>
{
  "@context": "https://schema.org",
  "@type": "Person",
  "address": {
    "@type": "PostalAddress",
    "addressLocality": "San Antonio",
    "addressRegion": "TX",
    "postalCode": "78205"
  },
  "jobTitle": "Co-Founder & CTO, CyberFortress",
  "name": "Michael T. DeFelice",
  "alumniOf": "Ursinus College",
  "url": "https://mtdefelice.github.io",
  "sameAs" : [
    "https://www.linkedin.com/in/mtdefelice",
    "https://twitter.com/mtdefelice"
  ]
}
</script>
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
