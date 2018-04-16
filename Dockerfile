FROM debian:wheezy

RUN apt-get update && apt-get -y install wget ca-certificates s3cmd cron rsyslog

# Use the postgresql repo to get version 9.4.1
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main' >> /etc/apt/sources.list \
 && wget -O- -q https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update && apt-get -y install postgresql-client-9.4

RUN touch /var/log/cron.log

COPY s3cfg /root/.s3cfg
COPY *.sh /root/
COPY rsyslog.conf /etc/
RUN chmod 0644 /etc/rsyslog.conf

COPY crontab /var/spool/cron/crontabs/root
RUN chmod 0600 /var/spool/cron/crontabs/root

# Run rsyslogd as that's how cron writes logs. Then save the environment to a file to load in the cron job,
# because cron by default runs jobs with a minimal environment and we want to include the passed in docker
# environment variables. Then just listen on the logs for changes.
CMD rsyslogd && cron && env > /root/env.sh && tail -f /var/log/syslog /var/log/cron.log
