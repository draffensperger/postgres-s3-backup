#!/bin/bash
# Usage: s3ackup_pg.sh [bucket] [postgres user] [postgres database]
# It pushes a postgres dump to that S3 bucket
# It appends a random string to the file for uniqueness purposes and so that
# you can limit the AWS user to only be able to push (not read) and thus the
# random string makes it so that, were the machine compromised, that AWS account
# couldn't overwrite old backup files.
RAND_STR=`cat /dev/urandom | head -c 30 | base64 | sed -e 's/+/_/g' -e 's/\\//-/g'`
TMP_FILE=/tmp/$RAND_STR.dump
touch $TMP_FILE
chmod 0600 $TMP_FILE
pg_dump -h $4 -U $2 $3 -F t -f $TMP_FILE
s3cmd --config /root/.s3cfg put $TMP_FILE s3://$1/$2/$2.`/bin/date +%Y_%m_%d`.$RAND_STR.dump
rm $TMP_FILE
