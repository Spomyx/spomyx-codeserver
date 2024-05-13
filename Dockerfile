FROM mcr.microsoft.com/vscode/devcontainers/go:latest

RUN <<EOF
apt-get update
apt-get install -y openssh-server vim docker.io docker-compose pacman-package-manager
apt-get clean
useradd -ms /bin/bash  lucas
usermod -aG sudo lucas
echo 'lucas ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
EOF

RUN curl -LO https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl
RUN curl -sS https://webinstall.dev/k9s | bash

USER lucas
WORKDIR /home/lucas

ENV GOPATH=/home/lucas/git/go

RUN <<EOF
code --install-extension ms-azuretools.vscode-docker
code --install-extension redhat.ansible
code --install-extension redhat.vscode-yaml
code --install-extension ms-python.python
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code --install-extension HashiCorp.terraform
EOF

ENTRYPOINT ["/usr/sbin/sshd", "-D"]