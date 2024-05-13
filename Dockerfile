FROM mcr.microsoft.com/vscode/devcontainers/go:latest

RUN <<EOF
apt-get update
apt-get install -y openssh-server vim podman
apt-get clean
useradd -ms /bin/bash  lucas
usermod -aG sudo lucas
echo 'lucas ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
EOF

USER lucas
WORKDIR /home/lucas

RUN curl -LO https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl
RUN curl -sS https://webinstall.dev/k9s | bash
# RUN wget https://downloads.nestybox.com/sysbox/releases/v0.6.4/sysbox-ce_0.6.4-0.linux_amd64.deb

ENV GOPATH=/home/lucas/git/go

ENTRYPOINT ["sudo", "/usr/sbin/sshd", "-D"]