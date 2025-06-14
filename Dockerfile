ARG BASE_IMAGE=mcr.microsoft.com/devcontainers/base:jammy
FROM ${BASE_IMAGE}

ENV CONDA_BIN_PATH /opt/conda/bin/conda
ENV MAMBA_BIN_PATH /opt/conda/bin/mamba
ENV CONDA_ENV_NAME devops

# BASIC APT PACKAGES #
RUN apt-get update && apt-get install -y software-properties-common
RUN apt-get install -y pkg-config
RUN apt-get install -y ffmpeg
RUN apt-get install -y htop
RUN apt-get clean

# MINIFORGE INSTALL #
COPY install_miniforge.sh /tmp/install_miniforge.sh
RUN chmod +x /tmp/install_miniforge.sh && /tmp/install_miniforge.sh
COPY environment.yml /tmp/environment.yml
RUN umask 0000 && ${CONDA_BIN_PATH} create -y -n ${CONDA_ENV_NAME}
RUN umask 0000 && ${CONDA_BIN_PATH} env update --file /tmp/environment.yml
RUN umask 0000 && /opt/conda/envs/${CONDA_ENV_NAME}/bin/pip install --upgrade jax
#RUN umask 0000 && /opt/conda/envs/${CONDA_ENV_NAME}/bin/pip install opencv-python opencv-contrib-python
COPY postCreateCommand.sh /tmp/postCreateCommand.sh
RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> /home/vscode/.bashrc
RUN echo "conda activate $CONDA_ENV_NAME" >> /home/vscode/.bashrc