FROM alpine:latest

USER root

# system packages
RUN apk update && apk upgrade
RUN apk add --no-cache \
    bash wget curl jq git openssh \
    python3 pipx

# python packages -> cuda-torch can only be installed on linux
# RUN pip install numpy pandas matplotlib seaborn
# RUN pip install torch torchvision torchaudio

# mount the current directory to the container, set as working directory
VOLUME ["/code"]
WORKDIR /code

# entrypoint
# CMD ["/bin/bash"]
