FROM ubuntu:14.04
STOPSIGNAL SIGTERM

# Install relevant stuff
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y emacs24-nox git python3 python3-dev python3-pip python-virtualenv

RUN pip3 install pytest

# Setup the "grader" user
RUN adduser grader
USER grader
WORKDIR /home/grader

COPY ./scripts scripts

# Just hang out until we get a SIGTERM (15) from 'docker stop'
CMD exec /bin/bash -c "trap 'echo Oh lawdy, I am dead. Got SIGTERMed. ; exit' 15; while true; do sleep 1; done"

# Back to root
USER root

# Setup the "student" user
RUN adduser student
USER student
WORKDIR /home/student

ENV PATH=/home/grader/scripts:$PATH

# We stay "student", so that the contained commands will run as "student"
