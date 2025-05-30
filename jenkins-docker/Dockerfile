FROM jenkins/jenkins:lts

USER root

# Install Docker CLI
RUN apt-get update && \
    apt-get install -y docker.io && \
    usermod -aG docker jenkins

# Optional: install docker-compose if needed
# RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" \
#     -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

USER jenkins

