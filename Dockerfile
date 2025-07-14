FROM mcr.microsoft.com/vscode/devcontainers/go:latest

RUN <<EOF
apt-get update
apt-get install -y openssh-server vim podman netcat-openbsd tmux npm 
apt-get clean
EOF

RUN <<EOF
groupadd -g 1001 lucas
useradd -u 1001 -g lucas -d /home/lucas -ms /bin/bash -k /etc/skel lucas
usermod -aG sudo lucas
echo 'lucas ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
mkdir /home/lucas/.ssh
chmod 700 /home/lucas/.ssh
chmod 754 /home/lucas
chown -R lucas:lucas /home/lucas/.ssh
EOF

RUN mkdir /var/run/sshd

WORKDIR /tmp/
RUN wget https://github.com/derailed/k9s/releases/download/v0.50.7/k9s_linux_amd64.deb
RUN dpkg -i k9s_linux_amd64.deb
RUN curl -LO https://dl.k8s.io/release/v1.33.1/bin/linux/amd64/kubectl
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

RUN curl -fsSL -o cmctl https://github.com/cert-manager/cmctl/releases/latest/download/cmctl_linux_amd64
RUN chmod +x cmctl
RUN sudo mv cmctl /usr/local/bin

USER lucas
WORKDIR /home/lucas

# RUN chmod 700 kubectl
# RUN mv kubectl .local/bin/.
# RUN wget https://downloads.nestybox.com/sysbox/releases/v0.6.4/sysbox-ce_0.6.4-0.linux_amd64.deb

ENV GOPATH=/home/lucas/go

RUN go install -a github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest
RUN go install github.com/brancz/gojsontoyaml@latest
RUN go install github.com/google/go-jsonnet/cmd/jsonnet@latest

ENTRYPOINT ["sudo", "/usr/sbin/sshd", "-D", "-e"]