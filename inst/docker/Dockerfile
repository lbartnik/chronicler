FROM ubuntu:18.04

# silence dpkg
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y

# required to configure packages
RUN apt-get install -y apt-utils

# required to add R repositories
RUN apt-get install -y gnupg ca-certificates

RUN echo "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/" > /etc/apt/sources.list.d/cran.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9

RUN echo "deb http://mirrors.ocf.berkeley.edu/ubuntu/ bionic-backports main restricted universe" >> /etc/apt/sources.list

# refresh apt
RUN apt-get update && apt-get upgrade -y

# install base R
RUN apt-get install -y r-base-dev

# install various dependencies for R packages that follow
RUN apt-get install -y libssl-dev libgit2-dev libssh2-1-dev libcurl4-gnutls-dev

RUN R -e 'install.packages("devtools")'

RUN R -e 'library(devtools); install_github("lbartnik/chronicler")'