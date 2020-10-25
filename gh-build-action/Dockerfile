FROM debian:buster

RUN apt update

RUN DEBIAN_FRONTEND=noninteractive apt install -q -y \
  lyx \
  texlive-pstricks \
  texlive-lang-chinese \
  texlive-lang-cyrillic \
  texlive-fonts-extra \
  git \
  texlive-humanities \
  pdftk \
  hunspell \
  bzip2

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

