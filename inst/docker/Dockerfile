FROM lbartnik/chronicler-base:18.04

WORKDIR /tmp

# install chronicler
USER user
ENV HOME /home/user
WORKDIR /home/user

RUN mkdir -p /home/user/R/x86_64-pc-linux-gnu-library/3.5 \
    && R -e 'library(devtools); install_github("lbartnik/chronicler")' \
    && rm -fr /tmp/*

# clean up

ENTRYPOINT [ "/usr/bin/rstudio" ]
