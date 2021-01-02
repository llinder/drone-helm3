FROM alpine/helm:3.2.4
MAINTAINER Erin Call <erin@liffft.com>

COPY build/drone-helm /bin/drone-helm
COPY assets/kubeconfig.tpl /root/.kube/config.tpl

RUN set -ex \
  && apk add --no-cache curl ca-certificates \
  && curl -o /tmp/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2020-11-02/bin/linux/amd64/aws-iam-authenticator \
  && chmod +x /tmp/aws-iam-authenticator \
  && mv /tmp/aws-iam-authenticator /bin/aws-iam-authenticator \
  && rm -rf /tmp/*	  && rm -rf /tmp/*

LABEL description="Helm 3 plugin for Drone 3"
LABEL base="alpine/helm"

ENTRYPOINT [ "/bin/drone-helm" ]
