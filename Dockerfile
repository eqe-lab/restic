FROM ghcr.io/eqe-lab/cronjob:latest

# Install required packages
RUN apk update && apk add --no-cache \
    restic wget \
    && rm -rf /var/cache/apk/*

# Set environment variables
ENV HOME=/restic \
    RESTIC_USER= \
    RESTIC_PASSWORD= \
    RESTIC_PASSWORD_FILE= \
    RESTIC_HOST= \
    RESTIC_ENV=restic-env \
    RESTIC_CMD=restic-run.sh \
    INTERPR=bash \
    RUN_SPECIFIC_TASK=/restic/.backupbox-phys/restic-run.sh

# Create RESTIC_DIR
RUN mkdir -p ${HOME}/.backupbox-phys && \
    mkdir -p ${ENTRYPOINTS_DIR} \
    mkdir -p /config && \
    touch /config/includes /config/excludes-global /config/excludes-global && \
    ln -s /config/includes ${HOME}/.backupbox-phys/includes && \
    ln -s /config/excludes-global ${HOME}/.backupbox-phys/excludes-global && \
    ln -s /config/excludes-local ${HOME}/.backupbox-phys/excludes-local

# Download and modify the restic-run.sh script
RUN wget https://backupbox.phys.ethz.ch/data/restic-run.sh -O ${HOME}/.backupbox-phys/${RESTIC_CMD} && \
    sed -i "1s/#SHELL#/${INTERPR}/" ${HOME}/.backupbox-phys/${RESTIC_CMD} && \
    chmod +x ${HOME}/.backupbox-phys/${RESTIC_CMD}

# Add entrypoint scripts
ADD scripts ${ENTRYPOINTS_DIR}

WORKDIR ${HOME}/.backupbox-phys
