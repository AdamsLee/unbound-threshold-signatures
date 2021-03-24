FROM rtfpessoa/ubuntu-jdk8:2.0.40

MAINTAINER  Adams Lee "adamslee@outlook.com"

RUN apt-get update && \
	apt install -y make && \
    apt install -y make-guile && \
    apt-get install -y gcc && \
    apt-get install -y g++ && \
    apt-get install -y openssl && \
    apt-get install -y libssl-dev

WORKDIR /usr/share

RUN git clone https://github.com/unbound-tech/blockchain-crypto-mpc.git && \
    cd blockchain-crypto-mpc && \
    make

ENV LD_LIBRARY_PATH=/usr/share/blockchain-crypto-mpc

RUN apt-get install -y --no-install-recommends \
    python3.7 \
    python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y iputils-ping && \
    apt-get install -y telnet

RUN pip3 install python-bitcoinlib ecdsa

EXPOSE 15435

VOLUME ["/usr/share/blockchain-crypto-mpc/data", "/usr/share/workspace-crypto-mpc"]

ENTRYPOINT ["tail", "-f", "/dev/null"]