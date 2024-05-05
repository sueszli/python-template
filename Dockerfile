# i want: pytorch, jupyter notebook via port 8888 localhost

FROM ubuntu:latest

# get system dependencies
RUN apt-get update && apt-get install -y \
    git \
    python3 python3-pip

# install python dependencies
# torch torchvision torchaudio \
RUN pip install --no-cache-dir \
    numpy pandas \ 
    jupyter jupyterlab jupyter_contrib_nbextensions \
    --break-system-packages

ENV JUPYTER_ENABLE_LAB=yes
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root", "--ServerApp.token=''", "--ServerApp.password=''", "--ServerApp.allow_origin='*'", "--ServerApp.disable_check_xsrf=True"]

EXPOSE 8888
