#Kubectl-docker image:

The Dockerfile creates a Kubectl command-line tool to configure Amazon's EKS cluster kubeconfig.

Use the below Dockerfile to create your own EKS kubectl-docker image.

#Dockerfile:
```
FROM alpine
LABEL maintainer="Surya Lolla surya.lolla@levvel.io"  

# Install curl, python3, pip3, aws-cli and set PATH
RUN apk --no-cache add curl python3 && \
    python3 -m ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    pip3 install awscli --upgrade --user

ENV PATH /root/.local/bin:$PATH

# Set AWS Arguments
ARG AWS_KEY
ARG AWS_SECRET_KEY
ARG AWS_REGION

# Configure AWS arguments
RUN aws configure set aws_access_key_id $AWS_KEY \
    && aws configure set aws_secret_access_key $AWS_SECRET_KEY \
    && aws configure set default.region $AWS_REGION

# Install aws-iam-authenticator
RUN curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.13.7/2019-06-11/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x ./aws-iam-authenticator && \
    mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$HOME/bin:$PATH

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl
```

Build the docker file with the below command with build arguments,
```
docker build -t <repository name>/<image name>:<tag>
    --build-arg AWS_KEY="<your_aws_key>"
    --build-arg AWS_SECRET_KEY="<your_aws_secret_key>"
    --build-arg AWS_REGION=<eks_aws_region>
```
