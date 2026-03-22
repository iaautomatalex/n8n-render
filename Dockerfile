FROM alpine/openclaw:latest

USER root

# Script de démarrage qui injecte la config depuis les env vars
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER 1000

EXPOSE 18789

ENTRYPOINT ["/entrypoint.sh"]
