FROM ubuntu
RUN rm -rf /etc/apt/sources.list \
    && mkdir -p /etc/php/7.4/fpm/pool.d/
COPY ./conf/sources.list /etc/apt/sources.list
COPY ./conf/timezone /etc/timezong

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt update && apt install -y tzdata \
    php7.4 \
    php7.4-mbstring \
    php7.4-fpm \
    php7.4-zip \
    php7.4-curl \
    php7.4-bz2 \
    php7.4-cgi \
    php7.4-pgsql \
    php7.4-json \
    php7.4-common \
    php7.4-xml \
    php7.4-sqlite3 \
    php7.4-mysql \
    php7.4-sybase \
    php7.4-xsl \
    php7.4-gd \
    vim \
    gcc \
    g++ \
    make \
    libpcre3 \
    libpcre3-dev \
    openssl \
    libssl-dev \
    curl \
    net-tools \
    && apt install -y ruby \
    && apt install -y zlib1g-dev \
    && useradd nginx \
    && mkdir -p /var/cache/nginx/clint_temp \
    && mkdir -p /etc/nginx \
    && mkdir -p /etc/nginx/project \
    && mkdir /etc/nginx/cert \
    && chmod -R 755 /etc/nginx/project \
    && curl http://tengine.taobao.org/download/tengine-2.3.2.tar.gz >> tengine.tar.gz \
    && tar zxf tengine.tar.gz \
    && cd tengine-2.3.2 \
    && chmod +x configure \
    && ./configure --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --user=nginx \
    --group=nginx \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_auth_request_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-file-aio \
    --with-ipv6 \
    && make && make install \
    && rm -rf composer_setup \
    && rm -rf /etc/nginx/nginx.conf \
    && cd .. \
    && rm -rf tengine*
    # 下载composer，网络问题，注释
    # && curl https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer >> composer_setup \
    # && php composer_setup \
    # && mv composer.phar /usr/bin/composer

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./conf/cert /etc/nginx/cert
COPY ./composer /usr/bin/composer

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/bin/bash","-c","/start.sh"]
EXPOSE 80