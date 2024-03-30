# Source code

The full source of the book is in the subdirectory `sofp-src/`.

The subdirectories `cover` and `lyx` contain source files and are edited.

The subdirectory `tex` contains generated TeX files.

# Building a PDF version of the book from LyX sources

If you want to build from source, currently you need `LyX` 2.3.x and `pdftk` installed.

Change to the directory `sofp-src`.

The command `bash make_sofp_pdf.sh` builds PDF files `sofp.pdf` and `sofp-10pt.pdf`.

If this does not work, you can build manually with a simple command such as `lyx --export pdf sofp.lyx`,
but the resulting PDF version will lack certain cosmetic features such as special colors and formatting.

If you do not have `LyX`, you can build from the provided LaTeX sources using commands such as:

```bash
cd tex/
pdflatex --interaction=batchmode sofp.tex
makeindex sofp.idx
pdflatex --interaction=batchmode sofp.tex
```

# Docker image for PDF builds

A Docker image (containing a compatible version of LyX and LaTeX) is configured by the repository https://github.com/winitzki/sofp-docker-build
and is automatically uploaded to Docker Hub at https://hub.docker.com/repository/docker/winitzki/sofp-docker-build/builds

This Docker image is loaded by the file [build-pdf.yml](.github/workflows/build-pdf.yml#L31) in order to build the PDF version of the book.

The latest build is uploaded to Github when a new git tag is pushed.
This happens with each new release.
Also, a PDF build is performed on every commit to master.
