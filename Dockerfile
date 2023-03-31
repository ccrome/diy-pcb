from ubuntu:22.04
# from continuumio/anaconda3:2022.10
RUN apt update
RUN apt upgrade -y
RUN apt install -y curl git
RUN curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh" && bash Mambaforge-$(uname)-$(uname -m).sh -b
ENV PATH=/root/mambaforge/bin:$PATH
RUN mamba init
RUN mamba create -y -n flatcam python=3.6.6 pip

RUN . ~/.bashrc && mamba activate flatcam && mamba install -y pyqt=4.11
COPY requirements.txt /tmp/requirements.txt
RUN . ~/.bashrc && mamba activate flatcam && pip install -r /tmp/requirements.txt
WORKDIR /app
RUN git clone https://bitbucket.org/jpcgt/flatcam.git
RUN apt install -y xvfb
WORKDIR /app/flatcam

ENV DISPLAY=:99
RUN echo "mamba activate flatcam" >> ~/.bashrc
CMD (nohup Xvfb :99 -screen 0 1000x1000x16 &) &&  /bin/bash
