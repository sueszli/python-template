FROM ubuntu:latest

# get system dependencies
RUN apt-get update && apt-get install -y git python3 python3-pip

# mount workspace
COPY . /workspace
WORKDIR /workspace
VOLUME [ "/workspace" ]

# install python dependencies
RUN pip install --no-cache-dir --break-system-packages \
    numpy pandas \
    torch torchvision torchaudio

# optional: jupyter server
RUN pip install jupyter jupyterlab jupyter_contrib_nbextensions
ENV JUPYTER_ENABLE_LAB=yes
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--no-browser", "--ServerApp.token=''", "--ServerApp.password=''", "--ServerApp.allow_origin='*'", "--ServerApp.disable_check_xsrf=True", "--ServerApp.allow_root=True", "--ServerApp.open_browser=False", "--ServerApp.disable_check_xsrf=True", "--ServerApp.disable_check_xsrf=True"]
EXPOSE 8888

# CMD ["tail", "-f", "/dev/null"]
