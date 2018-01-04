#!/bin/sh

chown -R www-data:www-data /data

# config
cat <<CONFIG > /etc/lsyncd/custom.lua
----
-- User configuration file for lsyncd.
--
-- Make sure to add correct permissions.
-- "CloseWrite or Modify" is required for docker "mv" events to function correctly
--
settings {
    statusFile = "/tmp/lsyncd.stat",
    logfile = "/tmp/lsyncd.log",
    statusInterval = 1,
    nodaemon = true,
    inotifyMode = "CloseWrite or Modify",
}

sync {
    default.rsync,
    source="/var/www/",
    target="/data/",
    delete = "running",
    delay = ${DELAY},
    excludeFrom = "$EXCLUDE_FILE",
    rsync = {
      archive = true,
      chown = "www-data:www-data",
      verbose = true,
    }
}

CONFIG

exec "$@"
