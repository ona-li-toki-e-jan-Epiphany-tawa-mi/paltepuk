#!/bin/sh

# This file is part of paltepuk.
#
# Copyright (c) 2024 ona-li-toki-e-jan-Epiphany-tawa-mi
#
# paltepuk is free software: you can redistribute it and/or modify it under the
# terms of the GNU Affero General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# paltepuk is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along
# with paltepuk. If not, see <https://www.gnu.org/licenses/>.

# Easy and automatic installation script for secret data.



# Error on use of unset variables.
set -u

log() {
    echo "log:     $1"
}
warn() {
    echo "warning: $1" 2>&1
}
error() {
    echo "error:   $1" 2>&1
}
panic() {
    echo "fatal:   $1" 2>&1
    exit 1
}

# $! - the directory to test.
# $? - 0: the directory is empty.
#      1: the directory is not empty.
#      2: an error occured.
is_directory_empty() {
    listing=$(ls "$1")
    # shellcheck disable=SC2181 # Contextless complaint about using $? directly.
    [ 0 -eq $? ] || return 2
    if [ -z "$listing" ]; then
        return 0
    else
        return 1
    fi
}



################################################################################
# Argument Parsing START                                                       #
################################################################################

if [ 1 -gt $# ]; then
    cat <<EOF
Usage: $0 SECRETS_DIRECTORY

Installs the secrets from SECRETS_DIRECTORY to their respective locations in the
filesystem. !!WARNING!!: running this script will overwrite the existing
installed secrets!

i2pd in-tunnel keys (.dat files) are expected to be in
SECRETS_DIRECTORY/i2pd-keys/.

Tor onion service private keys are expected to be in
SECRETS_DIRECTORY/tor-onions/<name>/.

EOF
    exit
fi

secrets=$1
[ -d "$secrets" ] || panic "secrets directory '$secrets' either does not exist or is not a directory"

i2pd_keys=$secrets/i2pd-keys
[ -d "$i2pd_keys" ] || panic "i2pd keys directory '$i2pd_keys' either does not exist or is not a directory"

tor_onions=$secrets/tor-onions
[ -d "$tor_onions" ] || panic "Tor onion service directory '$tor_onions' either does not exist or is not a directory"

################################################################################
# Argument Parsing END                                                         #
################################################################################



################################################################################
# Setup START                                                                  #
################################################################################

if [ "0" != "$(id -u)" ]; then
    panic 'this script must be run as the root user'
fi

tor_onion_directory=/var/lib/tor/onion
if [ ! -d "$tor_onion_directory" ]; then
    panic "'$tor_onion_directory' does not exist. Is Tor installed?"
fi
i2pd_directory=/var/lib/i2pd
if [ ! -d "$i2pd_directory" ]; then
    panic "'$i2pd_directory' does not exist. Is i2pd installed?"
fi

log 'stopping i2pd.service...'
systemctl stop i2pd.service || warn 'failed to stop i2pd.service'
log 'stopping tor.service...'
systemctl stop tor.service || warn 'failed to stop tor.service'

echo
echo '---------------------------------------------'
echo 'Are you SURE you want to continue?'
echo 'This will overwite existing installed secrets'
echo 'Press ENTER to continue. Press C-c to abort'
echo '---------------------------------------------'
# shellcheck disable=SC2034,SC2162 # We don't care what the user entered, but a
# variable is required by POSIX.
read ignore

################################################################################
# Setup END                                                                    #
################################################################################



################################################################################
# Install START                                                                #
################################################################################

# Warning for stopping midway.
trap "error 'script was stopped at an incomplete state, anything goes!'" EXIT

is_directory_empty "$i2pd_keys"; result=$?
if [ 1 -eq $result ]; then
    log 'removing existing i2pd keys...'
    rm -v "{$i2pd_directory:?}"/*.dat 2>/dev/null
    log 'installing new i2pd keys...'
    cp -v "${i2pd_keys:?}"/*.dat $i2pd_directory || error "failed to copy from '$i2pd_keys' to '$i2pd_directory'"
    chown -c i2pd:i2pd "${i2pd_directory:?}"/*.dat || error "failed to change ownership of keys installed to '$i2pd_directory' to i2pd:i2pd"
elif [ 2 -eq $result ]; then
    error "failed to read $i2pd_keys; skipping installation of new i2pd keys"
else
    warn "$i2pd_keys is empty; skipping installation of new i2pd keys"
fi

is_directory_empty "$tor_onions"; result=$?
if [ 1 -eq $result ]; then
    log 'removing existing Tor onion services...'
    rm -vr "${tor_onion_directory:?}"/* 2>/dev/null
    log 'installing new Tor onion services...'
    cp -v "${tor_onions:?}"/* "$tor_onion_directory" || error "failed to copy from '$tor_onions' to '$tor_onion_directory'"
    chown -cR tor:tor "${tor_onion_directory:?}"/* || error "failed to change ownership of onion services installed to '$tor_onion_directory' to tor:tor"
elif [ 2 -eq $result ]; then
    error "failed to read $tor_onions; skipping installation of new Tor onion services"
else
    warn "$tor_onions is empty; skipping installation of new Tor onion services"
fi

# Removes incomplete run warning.
trap '' EXIT

log 'restarting i2pd.service...'
systemctl start i2pd.service || error 'failed to restart i2pd.service'
log 'restarting tor.service...'
systemctl start tor.service || error 'failed to restart tor.service'

log 'installation complete'

################################################################################
# Install END                                                                  #
################################################################################
