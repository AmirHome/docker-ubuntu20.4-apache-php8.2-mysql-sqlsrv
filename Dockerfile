FROM ubuntu:20.04

# Set main parameters
ARG BUILD_ARGUMENT_ENV=dev
ENV ENV=$BUILD_ARGUMENT_ENV
ENV APP_HOME /var/www/html
ARG HOST_UID=1000
ARG HOST_GID=1000
ENV USERNAME=www-data

ENV TZ=Europe/Istanbul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    git \
    nano \
    zip \
    unzip

# Install PHP and Apache dependencies
RUN add-apt-repository ppa:ondrej/php -y && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apache2 \
    libapache2-mod-php8.2 \
    openssl \
    php8.2 \
    php8.2-curl \
    php8.2-dev \
    php8.2-gd \
    php8.2-mbstring \
    php8.2-zip \
    php8.2-xml \
    php8.2-mysql \
    locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Install ODBC and SQL Server drivers
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql17 && \
    ACCEPT_EULA=Y apt-get install -y mssql-tools && \
    apt-get install -y unixodbc-dev && \
    pecl install sqlsrv && \
    pecl install pdo_sqlsrv && \
    printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/8.2/mods-available/sqlsrv.ini && \
    printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/8.2/mods-available/pdo_sqlsrv.ini && \
    phpenmod -v 8.2 sqlsrv pdo_sqlsrv

# Install Node.js and NVM
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs build-essential libssl-dev && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash && \
    export NVM_DIR="/root/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    nvm install v18.15.0

# Install additional PHP extensions
RUN apt-get install -y php8.2-gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Disable default site and delete all default files inside APP_HOME
RUN a2dissite 000-default.conf && \
    rm -rf $APP_HOME/*

# Create document root, fix permissions for www-data user, and change owner to www-data
RUN mkdir -p $APP_HOME/public && \
    mkdir -p /home/$USERNAME && \
    chown $USERNAME:$USERNAME /home/$USERNAME && \
    usermod -o -u $HOST_UID $USERNAME -d /home/$USERNAME && \
    groupmod -o -g $HOST_GID $USERNAME && \
    chown -R ${USERNAME}:${USERNAME} $APP_HOME

# Copy Apache configurations
COPY apache2.conf /etc/apache2/
COPY default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY 000-virtualhost.conf /etc/apache2/sites-enabled/000-default.conf

# Enable Apache modules
RUN a2enmod rewrite ssl

EXPOSE 80
EXPOSE 443

WORKDIR $APP_HOME

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
