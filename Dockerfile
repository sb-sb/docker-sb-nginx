FROM debian:stretch-slim

ARG PACKAGE_VERSION="=1.15.12-1sb+111b+stretch1"
ARG PACKAGE_REPO="https://mirrors.xtom.com/sb/nginx"

RUN deps='apt-transport-https curl gnupg'; \
    set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates gettext-base $deps; \
    curl -fsSL $PACKAGE_REPO/public.key | apt-key add -; \
    echo "deb $PACKAGE_REPO stretch main" > /etc/apt/sources.list.d/sb-nginx.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends nginx$PACKAGE_VERSION; \
    apt-get purge -y --auto-remove $deps; \
    rm -rf /var/lib/apt/lists/*; \
    ln -sf /dev/stdout /var/log/nginx/access.log; \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY docker-nginx-*.sh docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
