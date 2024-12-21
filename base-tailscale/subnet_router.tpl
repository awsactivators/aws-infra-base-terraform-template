#! /bin/bash
hostnamectl set-hostname ${hostname}

# update
echo ""
echo "Running updates and installing dependencies"
echo "==========================================="
echo ""

apt-get update && apt-get upgrade -y && apt-get autoremove && apt-get autoclean
apt-get install -y awscli auditd libnl-genl-3-200 git-flow emacs python3-pip
apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# audit log
echo ""
echo "Setting up auditlog"
echo "==========================================="
echo ""
aws s3 cp s3://dod-analysis-server-conf/auditd-master/audit.rules /etc/audit/audit.rules
service auditd start

# CloudWatch Agent
echo ""
echo "Setting up CloudWatch Agent"
echo "==========================================="
echo ""
cd /tmp
wget -q https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
dpkg -i -E ./amazon-cloudwatch-agent.deb
echo '${log_config_json}' >/tmp/log_config.json
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -s -m ec2 -c file:/tmp/log_config.json
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a start

# Falcon sensor
echo ""
echo "Setting up Falcon Sensor"
echo "==========================================="
echo ""
cd /tmp
aws s3 cp s3://dod-analysis-server-config/falcon-sensor_6.26.0-12304_amd64.deb .
dpkg -i -E falcon-sensor_6.26.0-12304_amd64.deb
/opt/CrowdStrike/falconctl -s --cid=${falcon_cid}
service falcon-sensor start

# Add the user (--gecos "" ensures that this runs non-interactively)
echo ""
echo "Setting up useraccount"
echo "==========================================="
echo ""
username=${username}

adduser --disabled-password --gecos "" $username

# ssh key
mkdir /home/$username/.ssh
echo "${public_key}" >/home/$username/.ssh/authorized_keys
chown -R $username:$username /home/$username/.ssh

# Tailscale
curl -fsSL https://tailscale.com/install.sh | sh
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf

# Advertise the device as a subnet router
sudo tailscale up -auth-key ${authKey} --advertise-routes=${routes} --accept-dns=false 


# docker
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04-de
echo ""
echo "Setting up docker"
echo "==========================================="
echo ""
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-get update
apt-get install -y docker-ce
usermod -aG docker ${username}