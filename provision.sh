#!/bin/bash

set -o errexit

LIXA_VERSION=${version}
LIXA_RUN_TESTS=${run_tests}

version=$(cat /etc/redhat-release | awk '{print $4}')
if [ "$version" \> "7.0" ]
then
    version="7"
else
    version="6"
fi

# Install Postgres
has=$(rpm -qa | grep gdg-centos96 | wc -l)
if [ ${has} -eq 0 ]
then
    sudo yum install -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-${version}-x86_64/pgdg-centos96-9.6-3.noarch.rpm
    sudo yum groupinstall -y "PostgreSQL Database Server 9.6 PGDG"
    sudo yum install -y postgresql96-devel

    if [ "$version" = "6" ]
    then
        sudo service postgresql-9.6 initdb
    else
        sudo /usr/pgsql-9.6/bin/postgresql96-setup initdb
    fi

# Configure Postgres
sudo bash -c "cat > /var/lib/pgsql/9.6/data/pg_hba.conf" <<EOL
local   all             all                                     trust
host    all             all             127.0.0.1/32            trust
host    all             all             ::1/128                 trust
EOL

sudo bash -c "echo 'max_prepared_transactions = 100' >> /var/lib/pgsql/9.6/data/postgresql.conf" <<EOL
max_prepared_transactions = 100
EOL

    if [ "$version" = "6" ]
    then
        sudo chkconfig postgresql-9.6 on
        sudo service postgresql-9.6 start
    else
        systemctl enable postgresql-9.6.service
        systemctl start postgresql-9.6.service
    fi

# Create PG user and database
psql -U postgres <<EOF
\x
CREATE USER vagrant;
CREATE DATABASE testdb OWNER vagrant;
EOF

psql -U vagrant testdb <<EOF
\x
CREATE TABLE authors ("id" integer NOT NULL,"last_name" text,"first_name" text,CONSTRAINT "authors_pkey" PRIMARY KEY ("id"));
EOF
fi

# Install LIXA dependencies
sudo yum install -y gcc glib2-devel libxml2-devel libuuid-devel autoconf net-tools libffi-devel gettext-devel wget xz

if [ "$LIXA_VERSION" \> "1.1.1" ] && [ "$version" = "6" ]
then
    wget http://ftp.gnome.org/pub/GNOME/sources/glib/2.32/glib-2.32.4.tar.xz
    tar -xf glib-2.32.4.tar.xz
    cd glib-2.32.4
    ./configure
    sudo make install
    cd ..
    sudo rm -rf glib-2.32.4*

    CONF_EXTRA="PKG_CONFIG_PATH=/usr/local/lib/pkgconfig"
else
    CONF_EXTRA=""
fi

# Install LIXA
echo "Installing LIXA version: $LIXA_VERSION"

if [ -e lixa-$LIXA_VERSION ]
then
    sudo rm -rf lixa-$LIXA_VERSION
fi

echo "Fetching and installing LIXA..."
wget -q -O lixa.tar.gz https://github.com/tiian/lixa/archive/$LIXA_VERSION.tar.gz
tar -xzf lixa.tar.gz
rm lixa.tar.gz

# Assign permissions to "vagrant" user
sudo chown -R vagrant lixa-$LIXA_VERSION

# Compile
cd lixa-$LIXA_VERSION
sudo -u vagrant ${CONF_EXTRA} ./configure --enable-debug --enable-crash --with-postgresql=/usr/pgsql-9.6/bin/pg_config
sudo -u vagrant make

if [ "$LIXA_RUN_TESTS" = "true" ]
then
    echo "Running LIXA test campaign..."
    sudo -u vagrant make check
fi

sudo make install
cd ..

# Adjust PATH
echo "export PATH=\$PATH:/opt/lixa/bin:/opt/lixa/sbin" >> /home/vagrant/.bash_profile

# Set higher ulimit
#sudo bash -c 'echo "fs.file-max = 65536" >> /etc/sysctl.conf'
#sudo sysctl -p
#sudo bash -c "cat >> /etc/security/limits.conf" << EOL
#* soft     nproc          65535
#* hard     nproc          65535
#* soft     nofile         65535
#* hard     nofile         65535
#EOL

echo "Successfully Installed LIXA version: $LIXA_VERSION"
