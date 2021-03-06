
 
package databaseutils;
 
use DBI;
#use Config::IniFiles;
 
 sub connect_db {
	 
	 my $dbconfig = Config::IniFiles->new(
		-file => "C:/Users/<required-path-here>/dbinputcreds.ini"
	 );
	 
	 my $dbname = $dbconfig->val('ciw','dbname');
	 my $driver = $dbconfig->val('ciw','driver');
	 my $host = $dbconfig->val('ciw','host');
	 my $service_name = $dbconfig->val('ciw','service_name');
	 my $username = $dbconfig->val('ciw','username');
	 my $password = $dbconfig->val('ciw','password');
	 my $port = $dbconfig->val('ciw','port');
	 
	 my $dsn = "dbi:$driver:host=$host;sid=$sid;port=$port";
	 
	 my $dbh = DBI->connect("dbi:Oracle:host=$host;service_name=$service_name;port=$port",$username,$password) or die $DBI::errstr;
	 
	 return $dbh;
	 
 }
 
 sub connect_outputdb {
	 
	 my $dbconfig = Config::IniFiles->new(
		-file => "C:/Users/<required-path-here>/dboutputcreds.ini"
	 );
	 
	 my $dbname = $dbconfig->val('CUBLDIR','dbname');
	 my $driver = $dbconfig->val('CUBLDIR','driver');
	 my $host = $dbconfig->val('CUBLDIR','host');
	 my $service_name = $dbconfig->val('CUBLDIR','service_name');
	 my $username = $dbconfig->val('CUBLDIR','username');
	 my $password = $dbconfig->val('CUBLDIR','password');
	 my $port = $dbconfig->val('CUBLDIR','port');
	 
	 my $dsn = "dbi:$driver:host=$host;sid=$sid;port=$port";
	 
	 my $dbh = DBI->connect("dbi:Oracle:host=$host;service_name=$service_name;port=$port",$username,$password) or die $DBI::errstr;
	 
	 return $dbh;
	 
 }
 
 1;