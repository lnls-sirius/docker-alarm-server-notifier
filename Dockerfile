#
# Docker image for BEAST Alarm Server
#
# Author: Gustavo Ciotto Pinton
# LNLS - Brazilian Synchrotron Light Source Laboratory
#

FROM openjdk:latest

MAINTAINER Gustavo Ciotto <gustavo.pinton@lnls.br>

# Github environment variables
ENV GITHUB_ALARM_NOTIFIER_REPO https://github.com/ControlSystemStudio/org.csstudio.alarmserver.product.git
ENV GITHUB_ALARM_NOTIFIER_BRANCH master 

ENV ALARM_NOTIFIER_VERSION beast-alarm-notifier-4.1.1

# Alarm operation-related variables
ENV ALARM_NOTIFIER_FOLDER /opt/lnls-alarm-notifier

# Update image and install required packages
RUN apt-get -y update && apt-get install -y git maven postgresql-client && rm -rf /var/lib/apt/lists/*

COPY setup-notifier.sh ${ALARM_NOTIFIER_FOLDER}/build/scripts/

# Clone and compile alarm source code
RUN ${ALARM_NOTIFIER_FOLDER}/build/scripts/setup-notifier.sh

# create new folder and copy all scripts
RUN mkdir -p ${ALARM_NOTIFIER_FOLDER}/build/scripts/
      
# Copy provided configuration file

RUN mkdir -p ${ALARM_NOTIFIER_FOLDER}/${ALARM_NOTIFIER_VERSION}/configuration

COPY configuration/LNLS-CON.ini ${ALARM_NOTIFIER_FOLDER}/${ALARM_NOTIFIER_VERSION}/configuration

RUN mkdir ${ALARM_NOTIFIER_FOLDER}/${ALARM_NOTIFIER_VERSION}/scripts

COPY start-notifier.sh ${ALARM_NOTIFIER_FOLDER}/${ALARM_NOTIFIER_VERSION}/scripts

RUN git clone https://github.com/vishnubob/wait-for-it.git ${ALARM_NOTIFIER_FOLDER}/${ALARM_NOTIFIER_VERSION}/scripts/wait-for-it

CMD ["sh", "-c", "${ALARM_NOTIFIER_FOLDER}/${ALARM_NOTIFIER_VERSION}/scripts/start-notifier.sh"]
