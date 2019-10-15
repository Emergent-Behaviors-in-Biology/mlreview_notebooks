# Start from a core stack version
FROM jupyter/datascience-notebook:2ce7c06a61a1

# Install packages
USER root
RUN apt-get -qq update && \
    apt-get -qq install --yes --no-install-recommends \
        cmake \
        zlib1g-dev \
        mesa-common-dev

# Set up user
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV NB_UID ${NB_UID}
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

# Print python configuration details
RUN echo "Python path `which python`"
RUN echo "Python version: `python --version`"
RUN echo "Pip version: `pip --version`"
RUN pip install --upgrade pip
RUN echo "Pip version upgraded: `pip --version`"
RUN pip freeze

# Install conda packages
RUN conda install -y -c r r-rgl

# Install python pip packages from requirements.txt file
COPY requirements.txt /tmp/
RUN pip install --requirement /tmp/requirements.txt && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
RUN pip freeze

# Copy the contents of the repo to ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}
