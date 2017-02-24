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
  
  else

    echo -n "Installing Percona MySQL... "
    echo "percona-server-server-5.7 mysql-server/root_password password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
    echo "percona-server-server-5.7 mysql-server/root_password_again password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
    apt-get -yqq install percona-server-common-5.7 percona-server-client-5.7 percona-server-server-5.7 > /dev/null 2>&1
    sed -i 's/bind-address		= 127.0.0.1/#bind-address		= 127.0.0.1/' /etc/mysql/percona-server.conf.d/mysqld.cnf
    service mysql restart > /dev/null
    echo -e "[${green}DONE${NC}]\n"
  fi	
}
