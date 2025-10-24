FROM debian:13.1

ENV BW_CLI_VERSION=2025.8.0

RUN apt-get update && \
    apt list --upgradeable | grep security | cut -f1 -d '/' | xargs apt-get install --no-install-recommends -y && \
    apt-get install --no-install-recommends -y wget unzip ca-certificates && \
    wget --show-progress --progress bar https://github.com/bitwarden/clients/releases/download/cli-v${BW_CLI_VERSION}/bw-linux-${BW_CLI_VERSION}.zip && \
    unzip bw-linux-${BW_CLI_VERSION}.zip && \
    chmod +x bw && \
    mv bw /usr/local/bin/bw && \
    rm -rfv *.zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

COPY entrypoint.sh /usr/bin/entrypoint.sh

RUN chmod +x /usr/bin/entrypoint.sh

# create a user for non-root operation
ARG USER="user"
RUN useradd -ms /bin/bash $USER && \
        mkdir -p /home/$USER/.local/bin && \
        mkdir -p /home/$USER/.local/lib && \
        chown -R $USER:$USER /home/$USER/

# Swap to user account
USER $USER
WORKDIR /home/$USER/

CMD ["/bin/bash", "/usr/bin/entrypoint.sh"]
