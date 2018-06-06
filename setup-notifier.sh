#!/bin/bash

#
# A script to clone and build the alarm notifier application.
#
# Gustavo Ciotto Pinton
# Controls Group - Brazilian Synchrotron Light Source Laboratory
#

mkdir -p ${ALARM_NOTIFIER_FOLDER}/tmp

git clone -b ${GITHUB_ALARM_NOTIFIER_BRANCH} ${GITHUB_ALARM_NOTIFIER_REPO} ${ALARM_NOTIFIER_FOLDER}/tmp

ls  ${ALARM_NOTIFIER_FOLDER}/tmp

# Compile alarm server via Maven
( cd ${ALARM_NOTIFIER_FOLDER}/tmp/repository && mvn clean install )

# Copy and remove compiled binaries
cp -R ${ALARM_NOTIFIER_FOLDER}/tmp/repository/target/products/beast-alarm-notifier/linux/gtk/x86_64/${ALARM_NOTIFIER_VERSION} ${ALARM_NOTIFIER_FOLDER}
rm -r ${ALARM_NOTIFIER_FOLDER}/tmp

# Remove maven repositories and packages
rm -r ~/.m2
