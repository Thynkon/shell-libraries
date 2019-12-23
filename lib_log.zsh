#!/usr/bin/env zsh

# Import library that has a function that checks if a string
# contains a substring
. "$CURRENT_DIR/shell-libraries/lib_string.zsh"

current_shell=$(ps -p $$ | awk 'FNR == 2 {print $4}')

# In zsh, arrays start from 1 instead of 0
# This variable allows the script to be compatible with zsh and bash
ARRAY_START=0

# Using the constains function because in macOs, the current_shell
# variable is something like "-zsh"
contains $current_shell "zsh" && ARRAY_START=1

readonly LOG_EMERG=ARRAY_START
readonly LOG_ALERT=$((LOG_EMERG+1))
readonly LOG_CRIT=$((LOG_ALERT+1))
readonly LOG_ERR=$((LOG_CRIT+1))
readonly LOG_WARNING=$((LOG_ERR+1))
readonly LOG_NOTICE=$((LOG_WARNING+1))
readonly LOG_INFO=$((LOG_NOTICE+1))
readonly LOG_DEBUG=$((LOG_INFO+1))

# Set default log facility
readonly FACILITY="user"

# Set default verbose level
verbose_level=$LOG_ERR

.log() {
	local LOG_LEVELS=("emerg" "alert" "crit" "err" "warning" "notice" "info" "debug")
	local LEVEL=${1}

	if [ $verbose_level -ge $LEVEL ]; then
		echo "[${LOG_LEVELS[$LEVEL]}]" "$2"
		logger --id=$$ "$2" -p "$FACILITY.${LOG_LEVELS[$LEVEL]}"
	fi
}
