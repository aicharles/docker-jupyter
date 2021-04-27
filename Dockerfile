# slightly modified from https://github.com/jupyter/docker-stacks/blob/master/minimal-notebook/Dockerfile
ARG BASE_CONTAINER=jupyter/base-notebook
FROM $BASE_CONTAINER

USER root

# Install all OS dependencies for fully functional notebook server
RUN apt-get update && apt-get install -yq --no-install-recommends \
    build-essential \
    openssl \
    libssl-dev \
    vim-tiny \
    git \
    inkscape \
    libsm6 \
    libxext-dev \
    libxrender1 \
    lmodern \
    netcat \
    # ---- nbconvert dependencies ----
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-plain-generic \
    # ----
    tzdata \
    unzip \
    nano-tiny \
    mysql-server \
    default-libmysqlclient-dev \
    libpq-dev postgresql \
    software-properties-common \
    curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN add-apt-repository ppa:deadsnakes/ppa && apt update && apt install python3.9 python3.9-distutils python3.9-dev -y

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip && ./aws/install \
    && rm -rf aws

RUN apt-get update -yq \
    && apt-get -yq install gnupg ca-certificates \
    && curl -L https://deb.nodesource.com/setup_14.x | bash \
    && apt-get update -yq \
    && apt-get install -yq nodejs

RUN cp /usr/bin/node /usr/bin/node_bak && rm /usr/bin/node \
    && ln -s /usr/bin/nodejs /usr/bin/node \
    && jupyter lab clean \
    && jupyter lab build --minimize=False

RUN pip install pandas xlrd matplotlib \
    seaborn plotly "ipywidgets>=7.5" psycopg2 mysqlclient \
    paramiko ipykernel

RUN jupyter labextension install jupyterlab-plotly --no-build

RUN jupyter lab build --minimize=False

RUN curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py &&  \
    python3.9 get-pip.py && python3.9 -m pip install ipykernel && \
    python3.9 -m ipykernel install --name dlwp --display-name="Python3.9"

USER $NB_UID
