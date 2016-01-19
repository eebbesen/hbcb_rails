#!/bin/bash

PDFS=../data/pdf/*.pdf
for f in $PDFS
do
  echo "do $f"
  pdftotext -layout -table $f
  echo "done with $f"
done
