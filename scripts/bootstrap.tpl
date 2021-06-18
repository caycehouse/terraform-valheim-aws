#!/bin/bash

# Install docker
yum update -y
yum install -y docker

# Enable and start docker
systemctl --now enable docker

# Install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Make and mount our EBS volume
mkfs -t xfs /dev/sdb
mkdir -p /opt/valheim
mount /dev/sdb /opt/valheim
mkdir -p /opt/valheim/{config,data}
echo "/dev/sdb /opt/valheim xfs defaults 0 2" >> /etc/fstab

# Run the valheim docker instance
docker run -d \
    --name valheim-server \
    --cap-add=sys_nice \
    --stop-timeout 120 \
    --restart always \
    -p 2456-2457:2456-2457/udp \
    -v /opt/valheim/config:/config \
    -v /opt/valheim/data:/opt/valheim \
    -e SERVER_NAME="The Fryer's Valheim Server" \
    -e SERVER_PASS="${valheim_pass}" \
    -e STATUS_HTTP=true \
    lloesche/valheim-server
