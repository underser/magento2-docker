#!/bin/sh

/usr/sbin/varnishd -j unix,user=varnish -F -f /etc/varnish/default.vcl -a 0.0.0.0:80 -p http_resp_hdr_len=65536 -p http_resp_size=98304 -p workspace_backend=131072 -p workspace_client=131072 -s malloc,1g
