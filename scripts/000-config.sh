#!/usr/bin/env bash

RESTIC_DIR="${HOME}/.backupbox-phys"

if [ -z "$RESTIC_USER" ]; then
    echo "Please provide your restic user from the backupbox web interface: "
    exit 1
fi

if [ -z $RESTIC_HOST ]; then
    echo "Please provide your restic host from the backupbox web interface: "
    exit 1
fi

if [ -f "$RESTIC_PASSWORD_FILE" ]; then
    RESTIC_PASSWORD=$(cat $RESTIC_PASSWORD_FILE)
elif [ -z "$RESTIC_PASSWORD" ]; then
    echo "Please provide your restic password from the backupbox web interface: "
    exit 1
fi

cat << EOF > $RESTIC_DIR/$RESTIC_ENV
export RESTIC_USER="$RESTIC_USER"
export RESTIC_PASSWORD="$RESTIC_PASSWORD"
export RESTIC_REPOSITORY="rest:https://\$RESTIC_USER:\$RESTIC_PASSWORD@$RESTIC_HOST/\$RESTIC_USER"

EOF
chmod 600 $RESTIC_DIR/$RESTIC_ENV

