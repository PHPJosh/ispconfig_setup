#---------------------------------------------------------------------
# Function: InstallSQLServer
#    Install and configure SQL Server
#---------------------------------------------------------------------
InstallSQLServer() {
  if [ "$CFG_SQLSERVER" == "MySQL" ]; then
    echo -n "Installing MySQL... "
    echo "mysql-server-5.5 mysql-server/root_password password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
    echo "mysql-server-5.5 mysql-server/root_password_again password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
    apt-get -yqq install mysql-client mysql-server > /dev/null 2>&1
    sed -i 's/bind-address		= 127.0.0.1/#bind-address		= 127.0.0.1/' /etc/mysql/mysql.conf.d/mysqld.cnf
	echo "sql-mode=\"NO_ENGINE_SUBSTITUTION\"" >> /etc/mysql/mysql.conf.d/mysqld.cnf
    service mysql restart > /dev/null
    echo -e "[${green}DONE${NC}]\n"
  
    elif [ "$CFG_SQLSERVER" == "Percona Mysql" ]; then
    echo -n "Installing Percona MySQL... "
    echo "percona-server-server-5.7 percona-server-server/root_password password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
    echo "percona-server-server-5.7 percona-server-server/root_password_again password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
    wget https://repo.percona.com/apt/percona-release_0.1-4.$(lsb_release -sc)_all.deb > /dev/null 2>&1
    dpkg -i percona-release_0.1-4.$(lsb_release -sc)_all.deb > /dev/null 2>&1
    apt-get -qq update > /dev/null 2>&1    
    apt-get -yqq install percona-server-client-5.7 percona-server-server-5.7 > /dev/null 2>&1
    sed -i 's/bind-address		= 127.0.0.1/#bind-address		= 127.0.0.1/' /etc/mysql/percona-server.conf.d/mysqld.cnf
    service mysql restart > /dev/null
    echo -e "[${green}DONE${NC}]\n"
  
  else

    echo -n "Installing MariaDB 10.0 ... "
    #echo "mariadb-server-10.0 mysql-server/root_password password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
    #echo "mariadb-server-10.0 mysql-server/root_password_again password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
	apt-get -yqq install mariadb-client mariadb-server > /dev/null 2>&1
    sed -i 's/bind-address		= 127.0.0.1/#bind-address		= 127.0.0.1/' /etc/mysql/mariadb.conf.d/50-server.cnf
    service mysql restart /dev/null 2>&1
    echo -e "[${green}DONE${NC}]\n"
  fi	
}
