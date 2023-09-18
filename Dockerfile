FROM ubuntu:23.10

LABEL org.opencontainers.image.authors="schramm42@gmail.com"
LABEL version="1.0"

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV TZ=Europe/Berlin

SHELL ["/bin/bash", "-c"]

COPY etc/ /etc/
COPY install.sh /

RUN apt-get update -y \
    && apt-get -y install \
    apt-transport-https \
    ca-certificates

#RUN cp /etc/fortigate.crt /usr/local/share/ca-certificates/ && update-ca-certificates
RUN /install.sh

RUN apt-get -y install \
    imagemagick \
    nmap \
    wget \
    curl \
    nodejs \
    npm \
    micro \
    mc \
    httpie \
    bat \
    exa \
    lsd \
    lsb-release \
    duf \
    python3 \
    python3-pip \
    glances \
    rust-all

RUN wget --no-check-certificate https://go.dev/dl/go1.21.1.linux-amd64.tar.gz \
    && rm -rf /usr/local/go \
    && tar -C /usr/local -xvf go1.21.1.linux-amd64.tar.gz \
    && rm go1.21.1.linux-amd64.tar.gz

RUN echo "source /etc/profile" >> ~/.bashrc \
    && echo "export PATH=$PATH:/root/go/bin:/root/.cargo/bin" >> ~/.bashrc \
    && /usr/local/go/bin/go install \
        github.com/koki-develop/gat@latest 

# RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
# RUN bash ~/.nvm/nvm.sh install 20.6.1

RUN npm install --global \
    is-up-cli \
    iola \
    idea

RUN curl -sL https://raw.githubusercontent.com/wimpysworld/deb-get/main/deb-get | bash -s install deb-get
RUN deb-get install \
    du-dust

RUN cargo install \
    bottom \
    procs

# RUN apt-get autoremove -y \
# 	&& apt-get clean -y \
# 	&& rm -rf /var/lib/apt/lists/*