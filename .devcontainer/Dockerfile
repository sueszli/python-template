FROM alpine:latest

# copy everything
COPY . /code
WORKDIR /code

# system packages
# RUN apk update && apk upgrade
# RUN apk add --no-cache \
#     bash wget curl jq git openssh \
#     python3

# python packages -> cuda torch can only be installed on linux
# RUN pip3 install numpy pandas matplotlib seaborn
# RUN pip3 install torch torchvision torchaudio
