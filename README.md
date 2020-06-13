Dockerfile creates image for a jupyter notebook that can connect to Snowflake etc

To run it for the first time:

docker run -p 8888:8888  -v "$HOME/Documents":/home/jovyan/work -e JUPYTER_ENABLE_LAB=yes -e GRANT_SUDO=yes  --name jupyterlab custom-jupyterlab

and then:

docker run -p 8888:8888  -v "$HOME/Documents":/home/jovyan/work -e JUPYTER_ENABLE_LAB=yes -e GRANT_SUDO=yes  custom-jupyterlab
