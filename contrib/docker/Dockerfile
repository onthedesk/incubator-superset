FROM debian:stretch

# Add a normal user
RUN useradd --user-group --create-home --shell /bin/bash work

# Configure environment
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    HOME=/home/work

RUN apt-get update -y

# Install some dependencies
# http://airbnb.io/superset/installation.html#os-dependencies
# http://airbnb.io/superset/installation.html#os-dependencies
RUN apt-get update -y && \
    apt-get install -y build-essential \
    libssl-dev \
    libffi-dev \
    libsasl2-dev \
    libldap2-dev \
    curl \
    default-libmysqlclient-dev \
    freetds-dev \
    freetds-bin \
    libpq-dev \
    python3-dev \
    python3-pip \
    python-pip

# Install nodejs for custom build
# https://github.com/apache/incubator-superset/blob/master/docs/installation.rst#making-your-own-build
# https://nodejs.org/en/download/package-manager/
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -; \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list; \
    apt-get update; \
    apt-get install -y yarn

RUN apt-get clean && \
    rm -r /var/lib/apt/lists/*

RUN mkdir $HOME/incubator-superset

WORKDIR $HOME/incubator-superset

COPY ./ ./

RUN pip install --upgrade setuptools pip
RUN pip install -e . && pip install -r requirements-dev.txt

RUN pip install \
    Werkzeug==0.12.1 \
    flask-cors==3.0.3 \
    flask-mail==0.9.1 \
    flask-oauth==0.12 \
    flask_oauthlib==0.9.3 \
    gevent==1.2.2 \
    impyla==0.14.0 \
    infi.clickhouse-orm==0.9.8 \
    mysqlclient==1.3.7 \
    psycopg2==2.6.1 \
    pyathena==1.2.5 \
    pyhive==0.5.1 \
    pyldap==2.4.28 \
    pymssql==2.1.3 \
    redis==2.10.5 \
    sqlalchemy-clickhouse==0.1.5.post0 \
    sqlalchemy-redshift==0.5.0

ENV PATH=/home/work/incubator-superset/superset/bin:$PATH \
    PYTHONPATH=./superset/:$PYTHONPATH

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat

COPY ./superset ./superset
RUN chown -R work:work $HOME

USER work

RUN cd superset/assets && yarn
RUN cd superset/assets && npm run build

HEALTHCHECK CMD ["curl", "-f", "http://localhost:8088/health"]

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 8088

