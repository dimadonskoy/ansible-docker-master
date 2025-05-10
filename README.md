![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white&style=flat-square)
![Ansible](https://img.shields.io/badge/Ansible-EE0000?logo=ansible&logoColor=white&style=flat-square)

# Ansible docker lightweight master container setup

Create and deploy lightweight ansible server (master node) with open ssh server .

## Dockerfile

```dockerfile
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jerusalem

# Install dependencies and set timezone
RUN apt-get update && \
    apt-get install -y tzdata bash openssh-server sudo git iputils-ping vim less readline-common python3 python3-pip && \
    ln -snf /share/zoneinfo/$TZ /localtime && \
    echo $TZ > /timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    pip3 install --no-cache-dir ansible && \
    mkdir /run/sshd

# Create a user with passwordless sudo and SSH access
RUN useradd -m ansible && \
    echo 'ansible:ansible' | chpasswd && \
    echo 'ansible ALL=(ALL) NOPASSWD:ALL' >> /sudoers && \
    mkdir -p /ansible/.ssh && \
    chown -R ansible:ansible /ansible/.ssh && \
    chmod 700 /ansible/.ssh && \
    # Set bash as default shell for ansible user
    usermod --shell /bash ansible

# Expose SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
```

## Docker Compose Configuration

```yaml
services:
  ansible:
    image: ansible-master
    build:
      context: .
      dockerfile: Dockerfile
    container_name: ansible-master-host
    ports:
      - "2221:22"
    volumes:
      - ~/.ssh/id_ed25519.pub:/home/ansible/.ssh/authorized_keys:ro
    restart: unless-stopped
```

## Steps to Build and Run

1. **Build the Docker Image**:
   ```bash
   docker-compose build
   ```

2. **Start the Container**:
   ```bash
   docker-compose up -d
   ```

3. **Access the Container via SSH**:
   Use the following command to SSH into the container:
   ```bash
   ssh -i ~/.ssh/id_ed25519 -p 2221 ansible@localhost
   ```

## Notes

- Ensure your SSH public key (`~/.ssh/id_ed25519.pub`) exists before starting the container.
- The container is configured to restart automatically unless stopped manually.

## Author

- Dmitri Donskoy
- crooper22@gmail.com

Feel free to contribute to this project by submitting issues or pull requests.