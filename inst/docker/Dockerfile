FROM ubuntu:18.04

WORKDIR /tmp

# silence dpkg
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y \
    \
# required to configure packages
    && apt-get install -y apt-utils \
    \
# required to add R repositories
    && apt-get install -y gnupg ca-certificates \
    \
# add CRAN
    && echo "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/" > /etc/apt/sources.list.d/cran.list \
    \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
    \
    && echo "deb http://mirrors.ocf.berkeley.edu/ubuntu/ bionic-backports main restricted universe" >> /etc/apt/sources.list \
    \
# refresh apt
    && apt-get update && apt-get upgrade -y \
    \
# set locale
    && apt-get install -y xkb-data locales \
    \
    && locale-gen "en_US.UTF-8" \
    \
    && LANG en_US.UTF-8 \
    \
# install tools
    && apt-get install -y curl vim mc \
    \
# install base R
    && apt-get install -y r-base-dev \
    \
# install various dependencies for R packages that follow
    && apt-get install -y libssl-dev libgit2-dev libssh2-1-dev libcurl4-gnutls-dev libtiff-dev libcairo-dev libxt-dev \
    \
# add a default user
    && adduser --disabled-password user \
    && chown -R user /home/user/

# install (known) dependencies for chronicler
RUN R -e 'install.packages("devtools")' \
    \
    && R -e 'install.packages(c("rlang", "htmlwidgets", "yaml", "glue", "digest", "styler",\
                                "shiny", "miniUI", "httpuv", "BH", "xtable", "sourcetools",\
                                "later", "promises", "broom", "bindcrpp", "tidyselect", "dplyr",\
                                "reshape2", "plyr", "stringr", "stringi", "bindr", "tidyr",\
                                "bindrcpp", "pkgconfig", "plogr", "lubridate", "png", "proto",\
                                "bmp", "tiff", "jpeg", "readbitmap", "downloader", "igraph",\
                                "Cairo", "imager", "testthat", "knitr", "rmarkdown"))'

# install RStudio's dependencies
RUN apt-get install -y libjpeg62 libssl1.0.0 libgstreamer1.0-0 libgstreamer-plugins-base1.0-0 libxslt1.1 \
    \
# install RStudio
    && curl https://download1.rstudio.org/rstudio-xenial-1.1.456-amd64.deb -o rstudio-xenial-1.1.456-amd64.deb \
    && dpkg -i rstudio-xenial-1.1.456-amd64.deb \
    && rm rstudio-xenial-1.1.456-amd64.deb \
    \
# configure RStudio
    && mkdir -p /home/user/.config/RStudio \
    && mkdir -p /home/user/.rstudio-desktop/monitored/user-settings/
COPY desktop.ini /home/user/.config/RStudio/
COPY user-settings /home/user/.rstudio-desktop/monitored/user-settings/

# install chronicler
USER user
ENV HOME /home/user
WORKDIR /home/user

RUN R -e 'library(devtools); install_github("lbartnik/chronicler@full-docker-build")'

# clean up
RUN apt-get clean
RUN rm -fr /tmp/*

ENTRYPOINT [ "/usr/bin/rstudio" ]
