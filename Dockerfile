FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jerusalem

# Install dependencies and set timezone
RUN apt-get update && \
    apt-get install -y tzdata bash openssh-server sudo git iputils-ping vim less readline-common python3 python3-pip && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    pip3 install --no-cache-dir ansible && \
    mkdir /var/run/sshd

# Create a user with passwordless sudo and SSH access
RUN useradd -m ansible && \
    echo 'ansible:ansible' | chpasswd && \
    echo 'ansible ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    mkdir -p /home/ansible/.ssh && \
    chown -R ansible:ansible /home/ansible/.ssh && \
    chmod 700 /home/ansible/.ssh && \
    # Set bash as default shell for ansible user
    usermod --shell /bin/bash ansible

# Expose SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

