ARG BASE_IMAGE=ubuntu:focal

# Disable frontend
ARG DEBIAN_FRONTEND=noninteractive
FROM ${BASE_IMAGE}

COPY /bd_build /bd_build

# Create user
RUN set -xe && \
    groupadd -g 1000 undies && \
    useradd -u 1000 -m -g 1000 undies

RUN /bd_build/prepare.sh && /bd_build/cleanup.sh

# Now install nodejs v16
RUN curl -sL https://deb.nodesource.com/setup_16.x -o /tmp/nodesetup.sh && \
    bash /tmp/nodesetup.sh && \
    clean_install nodejs

USER undies

WORKDIR /home/undies

# While this is a hacky solution it does work. It'll pull the newest version of each of these
RUN git clone https://github.com/GoByeBye/UNDIES.git && \
    cd UNDIES && \
    git submodule init && git submodule update


USER root
RUN mv /home/undies/UNDIES/submodules/ass /home/undies/ass && \
    mv /home/undies/UNDIES/submodules/dick /home/undies/ass/dick && \
    mv /home/undies/UNDIES/submodules/Log4Bash /Log4Bash

WORKDIR /home/undies/ass
RUN npm i -g typescript

USER undies
RUN npm i --save-dev
WORKDIR /home/undies/ass/dick
RUN npm i

COPY /scripts/startup.sh /startup.sh

CMD ["/startup.sh"]