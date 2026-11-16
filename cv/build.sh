#!/bin/bash
# Build the CV with TeX Live in Docker and copy the PDF into the site's assets.
set -e

cd "$(dirname "$0")"
NAME=Podshara_Chanrungmaneekul_CV

docker run --rm -u "$(id -u):$(id -g)" -e HOME=/tmp -v "$PWD":/work -w /work texlive/texlive:latest \
  latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build "$NAME.tex"

mkdir -p ../assets/pdf
cp "build/$NAME.pdf" "../assets/pdf/$NAME.pdf"
echo "Wrote assets/pdf/$NAME.pdf"
