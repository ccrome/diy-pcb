from ubuntu:22.04

RUN apt update
RUN apt upgrade -y
RUN apt install -y gerbv openscad patch xvfb curl git

RUN curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh" && bash Mambaforge-$(uname)-$(uname -m).sh -b
ENV PATH=/root/mambaforge/bin:$PATH
RUN mamba init
RUN mamba create -y -n flatcam python=3.6.6 pip

COPY requirements.txt /tmp/requirements.txt
COPY 0001-Fix-command-line-export_svg-command.patch /tmp
COPY examples /examples
COPY gerber2stl.py /app/gerber2stl.py

RUN . ~/.bashrc && mamba activate flatcam && mamba install -y pyqt=4.11
RUN . ~/.bashrc && mamba activate flatcam && pip install -r /tmp/requirements.txt
WORKDIR /app
RUN git clone https://bitbucket.org/jpcgt/flatcam.git
WORKDIR /app/flatcam
RUN patch -p 1 < /tmp/0001-Fix-command-line-export_svg-command.patch
RUN . ~/.bashrc && mamba activate flatcam && pip install -e .

ENV DISPLAY=:99
RUN echo "mamba activate flatcam" >> ~/.bashrc
COPY startup.sh /startup.sh
ENTRYPOINT ["/startup.sh"]


WORKDIR /examples

#ENTRYPOINT [ "python", "/app/gerber2stl.py" ]
#CMD ["/in.gerber", "/output.stl"]
