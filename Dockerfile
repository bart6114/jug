FROM r-base:3.3.1

# Install external dependencies
RUN apt-get update -qq \
  && apt-get install -t unstable -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libsqlite3-dev \
    libxml2-dev \
    qpdf \
    vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

RUN echo 'install.packages(c("devtools"), dependencies=TRUE)' > /tmp/packages.R
# install packages
RUN Rscript /tmp/packages.R
RUN echo 'devtools::install_github("Bart6114/jug", force=TRUE)' > /tmp/packages.R
RUN Rscript /tmp/packages.R

CMD [ "Rscript", "index.r" ]

EXPOSE 8080
