FROM r-base:3.3.1

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev

# note: devtools is only required if you want to install jug from github
RUN install2.r --error \
 devtools
#  jug

# remove below line and add 'jug' the above command in order to use the CRAN version
RUN Rscript -e "devtools::install_github('bart6114/jug')"

# jug instance configuration
ENV JUG_HOST 0.0.0.0
ENV JUG_PORT 8080

# for demo purposes a hello world example is served
COPY var/hello_world.R .

EXPOSE 8080

CMD [ "Rscript", "hello_world.R" ]
