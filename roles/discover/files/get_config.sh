#!/bin/bash
#
# An adaptation of request_tower_configuration.sh, which is
# shipped with Ansible Tower http://ansible.com/tower
#
# This version discovers the callback information from DNS
# See this blog for details: http://probably.co.uk/simple-service-discovery-using-ansible-tower-and-dns.html
#
# Mark Phillips <mark@ansible.com>

prog=$(basename $0)

# Only tested on Linux right now - so let's drop out with a warning to syslog
if [ $(uname -s) != 'Linux' ]; then
    logger "${prog}: OS not supported"
    exit 1
fi

if [ ! $(which dig) ]; then
    logger "${prog}: dig command not found. Install bind-utils package"
    exit 1
fi

if [ ! $(which curl) ]; then
    logger "${prog}: curl command not found (really?!). Install curl package"
    exit 1
fi

# Find Tower callback
# domain is expected to be found from dnsdomainname command. Can override with
# DOMAIN environment variable
#
domain=${DOMAIN:-$(dnsdomainname)}
tower=$(dig +short _cm._tcp.${domain} srv | awk '/^0/ {print $4}')
port=$(dig +short _cm._tcp.${domain} srv | awk '/^0/ {print $3}')
request=($(dig +short ${domain} txt | tr -d '"'))
template_key=${request[0]}
template_id=${request[1]}

if [[ -z $tower ]]; then
    logger "${prog}: could not find tower host"
    exit 1
fi

python -c "import socket; socket.create_connection((\"${tower}\",${port}),3)" 2>/dev/null
if [ $? -ne 0 ]; then
    logger "${prog}: Failed to connect to port ${port} of ${tower}: Aborting"
    exit 2
fi

retry_attempts=10
attempt=0
delay=30
while [[ $attempt -lt $retry_attempts ]]
do
    status_code=`curl -s -i --data "host_config_key=$template_key" http://$tower/api/v1/job_templates/$template_id/callback/ | head -n 1 | awk '{print $2}'`
    if [[ $status_code -eq 202 ]]; then
        exit 0
    fi
    attempt=$(( attempt + 1 ))
    logger "${prog}: ${status_code} received... retrying in ${delay} seconds (Attempt ${attempt})"
    sleep ${delay}
done
exit 1
