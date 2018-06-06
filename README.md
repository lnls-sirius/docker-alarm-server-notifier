# Alarm server notifier docker container

A debian-based docker container holding the EPICS alarm server notifier application.

Execute `build-docker-alarm-notifier.sh` to create the Docker image. To deploy, refer to this [project](https://github.com/lnls-sirius/docker-alarm-composed).

## Environment variables

This image uses two environment variables that can be passed when the container is launched. `SMTP_HOST` is the SMTP server's IP address and `SMTP_SENDER` is the destination email address.
