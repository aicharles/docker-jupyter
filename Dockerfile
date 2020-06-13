# slightly modified from https://github.com/jupyter/docker-stacks/blob/master/minimal-notebook/Dockerfile
ARG BASE_CONTAINER=jupyter/base-notebook
FROM $BASE_CONTAINER

USER root

# Install all OS dependencies for fully functional notebook server
RUN apt-get update && apt-get install -yq --no-install-recommends \
    curl \
    build-essential \
    emacs \
    git \
    inkscape \
    jed \
    libsm6 \
    libxext-dev \
    libxrender1 \
    lmodern \
    netcat \
    python-dev \
    # ---- snowflake stuff ---- #
    libssl-dev \
    libffi-dev \
    # ---- nbconvert dependencies ----
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    # Optional dependency
    texlive-fonts-extra \
    # ----
    tzdata \
    unzip \
    nano \
    postgresql libpq-dev postgresql-client postgresql-client-common \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip && ./aws/install \
    && rm -rf aws

RUN cp /usr/bin/node /usr/bin/node_bak && rm /usr/bin/node \
    && ln -s /usr/bin/nodejs /usr/bin/node \
    && jupyter lab clean \
    && jupyter lab build --minimize=False

RUN pip install pandas snowflake-sqlalchemy slackclient xlrd matplotlib \
    seaborn plotly "ipywidgets>=7.5" snowflake-ingest psycopg2

RUN jupyter labextension install jupyterlab-plotly --no-build

RUN jupyter lab build --minimize=False

USER $NB_UID
