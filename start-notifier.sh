#!/bin/bash

set -x

# Temporary data file
DATA=/tmp/${PROGRAM}.$$

# Launching options
OPT="-data ${DATA} -pluginCustomization ${ALARM_NOTIFIER_FOLDER}/${ALARM_NOTIFIER_VERSION}/configuration/LNLS-CON.ini -consoleLog -vmargs -Djava.awt.headless=true"

### Changes EPICS settings

# Updates smtp host
if [ ${SMTP_HOST+x} ]; then
    sed -i "s:org.csstudio.email/smtp_host=.*$:org.csstudio.email/smtp_host=${SMTP_HOST}:" ${ALARM_NOTIFIER_FOLDER}/${ALARM_NOTIFIER_VERSION}/configuration/LNLS-CON.ini
fi

if [ ${SMTP_SENDER+x} ]; then
    sed -i "s:org.csstudio.email/smtp_sender=.*$:org.csstudio.email/smtp_sender=${SMTP_SENDER}:" ${ALARM_NOTIFIER_FOLDER}/${ALARM_NOTIFIER_VERSION}/configuration/LNLS-CON.ini
fi

# Waits for database and ActiveMQ to be ready before lauching server

chmod +x ${ALARM_NOTIFIER_FOLDER}/${ALARM_NOTIFIER_VERSION}/scripts/wait-for-it/wait-for-it.sh

${ALARM_NOTIFIER_FOLDER}/${ALARM_NOTIFIER_VERSION}/scripts/wait-for-it/wait-for-it.sh alarm-server-activemq:61616

pg_isready -h alarm-server-postgres-db -p 5432
PG_READY=$?
while [  ${PG_READY} -ne 0 ]; do
	pg_isready -h alarm-server-postgres-db -p 5432
	PG_READY=$?
	sleep 1
done

# Launches server
${ALARM_NOTIFIER_FOLDER}/${ALARM_NOTIFIER_VERSION}/AlarmNotifier ${OPT} 2>&1
