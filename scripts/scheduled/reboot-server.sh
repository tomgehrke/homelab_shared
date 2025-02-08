#!/user/bin/env bash

logDir="/home/supertom/logs"
if [[ ! -d  "$logDir" ]]; then
        mkdir -p "$logDir"
fi

echo "$(date) - Rebooting server..." > "$logDir/reboot-server.log"
shutdown -r now
