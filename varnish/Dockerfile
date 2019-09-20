FROM debian:stretch

# Installation of Varnish5.

RUN apt-get -y update
RUN apt-get -y install curl gnupg2 apt-transport-https debian-archive-keyring
RUN curl -L https://packagecloud.io/varnishcache/varnish5/gpgkey | apt-key add -
RUN echo "deb https://packagecloud.io/varnishcache/varnish5/debian/ stretch main" | tee -a /etc/apt/sources.list.d/varnishcache_varnish5.list
RUN apt-get -y install varnish supervisor

# Copy vcl from host to container.

ADD ./default.vcl /etc/varnish/default.vcl
RUN chmod o+r /etc/varnish/default.vcl

# Create secret file.

RUN touch /etc/varnish/secret

# Copy startup script and allow it execution.

ADD varnish.sh /bin/varnish.sh
RUN chmod +x /bin/varnish.sh

EXPOSE 80

HEALTHCHECK --interval=1m --timeout=10s --retries=3 CMD varnishadm backend.list | grep -qis 'healthy' || exit 1

# Start Varnish by default.

CMD ["/bin/varnish.sh"]
