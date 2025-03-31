FROM ubuntu:22.04
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y curl && python -m pip install --upgrade pip
RUN pip install virtualenv && virtualenv /venv && \
    . /venv/bin/activate && \
    pip install setuptools -U && \
    pip install --upgrade pip && \
    pip install -r requirements.txt