# openconnect
Automatically vpn to a host by only keying in VIP access code from second time onwards.

openconnect is a bash shell script that establishes vpn connection to the provided host.
During First process of elstablishing connection it asks for:
1) Hostname
2) Username
3) Password
4) VIP Access code

From the Second time onwards it only needs "VIP Access code" and it automatically connects to the previously connected Host.

This script requires 'ssl-keygen' and 'openssl rsautl' to be available.

USAGE: openconnect 

    -h is the help flag and prints this message.
    -r is the refresh flag to begin setup as the First connection establishment.
