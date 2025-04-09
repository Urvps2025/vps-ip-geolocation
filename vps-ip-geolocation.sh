#!/bin/bash

echo "IP | País | Proveedor/Empresa | Reverse DNS"
echo "-------------------------------------------------------------"

netstat -tn | grep ESTABLISHED | awk '{print $5}' | cut -d: -f1 | sort -u | while read ip; do
    pais=$(geoiplookup "$ip" | grep Country | cut -d: -f2- | sed 's/^ //')
    proveedor=$(whois "$ip" | grep -Ei 'OrgName|netname|descr|owner' | head -n 1 | awk '{$1=""; print $0}' | sed 's/^ //')
    rdns=$(host "$ip" | grep pointer | awk '{print $5}' | sed 's/\.$//')
    
    [ -z "$rdns" ] && rdns="(sin PTR)"
    echo "$ip | $pais | $proveedor | $rdns"
done
