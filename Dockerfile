FROM debian:stretch

ARG BUNDLE_DIR

RUN apt-get update && apt-get install -y ca-certificates

# exec mixin has no buildtime dependencies

RUN apt-get update && apt-get install -y curl
RUN curl https://get.helm.sh/helm-v3.3.4-linux-amd64.tar.gz --output helm3.tar.gz
RUN tar -xvf helm3.tar.gz
RUN mv linux-amd64/helm /usr/local/bin/helm3
RUN helm3 repo add akri-helm-charts https://deislabs.github.io/akri
RUN helm3 repo update

COPY . $BUNDLE_DIR
RUN rm -fr $BUNDLE_DIR/.cnab
COPY .cnab /cnab
COPY porter.yaml $BUNDLE_DIR/porter.yaml
WORKDIR $BUNDLE_DIR
CMD ["/cnab/app/run"]