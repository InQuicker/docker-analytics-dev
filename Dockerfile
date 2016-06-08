FROM java

ENTRYPOINT ["/usr/local/bin/boot"]

VOLUME ["/.boot", "/m2", "/app"]

ENV SASS_VERSION=3.3.6 \
    SASS_LIBSASS_PATH=/tmp/libsass \
    BOOT_HOME=/.boot \
    BOOT_AS_ROOT=yes \
    BOOT_LOCAL_REPO=/m2 \
    BOOT_JVM_OPTIONS=-Xmx2g

RUN apt-get update && \
    apt-get -y install build-essential && \
    curl -LOs https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2 && \
    tar xjf phantomjs-1.9.8-linux-x86_64.tar.bz2 && \
    cp phantomjs-1.9.8-linux-x86_64/bin/phantomjs /usr/local/bin/ && \
    rm -r phantomjs-1.9.8-linux-x86_64 phantomjs-1.9.8-linux-x86_64.tar.bz2 && \
    git clone --branch $SASS_VERSION --depth 1 https://github.com/sass/libsass.git /tmp/libsass && \
    git clone --branch $SASS_VERSION --depth 1 https://github.com/sass/sassc.git /tmp/sassc && \
    cd /tmp/sassc && \
    make && \
    cp /tmp/sassc/bin/sassc /usr/local/bin/sassc && \
    curl -L -o /usr/local/bin/boot https://github.com/boot-clj/boot-bin/releases/download/latest/boot.sh && \
    chmod +x /usr/local/bin/boot && \
    apt-get -y remove build-essential && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app
