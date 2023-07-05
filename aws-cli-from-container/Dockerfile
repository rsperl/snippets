ARG VERSION="latest"

FROM public.ecr.aws/aws-cli/aws-cli:${VERSION}

RUN yum install -y tar gzip && \
    curl -L -o /tmp/eksctl.tar.gz "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" 
RUN tar -xzf /tmp/eksctl.tar.gz && rm /tmp/eksctl.tar.gz && \
    mv ./eksctl /usr/local/bin
