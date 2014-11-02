postgres-s3-backup
==================

Dockerized cron job to backup a postgres database to Amazon S3 every day at midnight.

It expects the following environment variables to be set:

PG_S3_BACKUP_BUCKET = the S3 buck to use for the backup
PG_S3_BACKUP_ACCESS_KEY = the AWS access key to authorize writing to the bucket
PG_S3_BACKUP_SECRET_KEY = the AWS secret key to authorize writing to the bucket
PG_S3_BACKUP_USER = the user of the postgres database (assumes this user can access without password and database hosted on localhost)
PG_S3_BACKUP_DB = the postgres database to backup

