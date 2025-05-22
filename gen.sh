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
<meta name = 'google-site-verification' content = 'FGLVbp7xPwYsTLzWL83Iydd2iuttuSHh6kWuS-vfDR0'>
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
  "jobTitle": "Co-Founder & CTO",
  "name": "Michael T. DeFelice",
  "alumniOf": "Ursinus College",
  "url": "https://mtdefelice.github.io",
  "sameAs" : [
    "https://www.linkedin.com/in/mtdefelice",
  ]
}
</script>
<title>Michael DeFelice</title>
</head>
<body>
<pre style = 'white-space: pre-wrap;'>
EOF

# Note: removed
# <a href = 'Resume-DeFelice_2021.pdf'>Click for a *.pdf version.</a>

cat cv-defelice_2025.txt >> $OUT

cat << EOF >> $OUT
</pre>
</body>
</html>
EOF
