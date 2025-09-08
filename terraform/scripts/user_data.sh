#!/bin/bash


# Update and install Docker
sudo dnf update -y
sudo dnf install -y docker amazon-cloudwatch-agent

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker


# Run n8n container
mkdir -p /home/ubuntu/n8n_data
cd /home/ubuntu/n8n_data
sudo docker volume create n8n_data


docker run -d \
 --name n8n \
 -p 5678:5678 \
 -e GENERIC_TIMEZONE="Asia/Dubai" \
 -e TZ="Asia/Dubai" \
 -e N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true \
 -e N8N_RUNNERS_ENABLED=true \
 -e AWS_REGION=us-east-1 \
 -e AWS_ACCESS_KEY_ID=$(echo $CREDS | jq -r .AccessKeyId) \
 -e AWS_SECRET_ACCESS_KEY=$(echo $CREDS | jq -r .SecretAccessKey) \
 -e AWS_SESSION_TOKEN=$(echo $CREDS | jq -r .Token) \
 -v n8n_data:/home/node/.n8n \
 docker.n8n.io/n8nio/n8n

cat <<EOT > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/lib/docker/containers/*/*.log",
            "log_group_name": "/n8n/docker",
            "log_stream_name": "{container_id}",
            "timestamp_format": "%Y-%m-%dT%H:%M:%S"
          }
        ]
      }
    }
  }
}
EOT

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s
EOF

