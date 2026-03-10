#! /usr/bin/env -S bash

for ip in $(hostname -I); do
    # Skip loopback addresses
    if [[ "$ip" =~ ^172\. || "$ip" == "::1" ]]; then
        continue
    fi

    dirname=$(realpath "${1-$PWD}")
    printf "$ip\t$USER@$ip:$dirname\n" 
done
