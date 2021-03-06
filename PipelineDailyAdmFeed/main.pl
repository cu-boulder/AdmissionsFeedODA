=pod 
*
* The Daily Admissions ODA Data Pipeline
*
* Tools used: Perl, PL/SQL, Oracle SQL, DBI Toolchest, Mailtrap Server
* version 1, April, 2022 
* 
* Lead: Robert Stubbs
* Dev: Pavan Kumar Narayanan
*
* Institutional Research, Office of Data Analytics, CU Boulder
*
=cut

# load the required Perl modules
use warnings;
use strict;
use DateTime;
use DBI;
use DBIx::Dump;
use Config::IniFiles;
use Log::Log4perl; 

use lib 'C:/Users/path-to-the-SASMacroConversions-lib';
use emailutils;
use databaseutils;
use fileutils;
#use postprocess;

my $dbh = databaseutils::connect_db();

#$dbh->do("alter session set current_schema = sysadm");
#$dbh->do(" alter session set nls_date_format='mm-dd-yyyy'");

sub preprocess {
	
	print "\nPreprocessing: Removing the table if exists";
	
	my $preprocess = fileutils::sqlfromfile("C:/Users/<required-path-here>/tablecheck.sql");
	
	$dbh->do($preprocess);
	
	print "\n\nPreprocessing Complete.";
	
	AdmDailyODA();
}	

sub AdmDailyODA {
	
		print "\n\nBegin processing AdmDailyODA...";
		
		my $createtemp1 = fileutils::sqlfromfile("C:/Users/<required-path-here>/AdmDailyFeedODA_DDL.sql");
		#$createtemp1->do();
		$dbh->do($createtemp1);

		my $admdaily = fileutils::sqlfromfile("C:/Users/pana5770/<required-path-here>/AdmDailyFeedODA_SQL_CTE.sql");
		
		my $sth1 = $dbh->prepare($admdaily);
		$sth1->execute();
		
		my $rows = $sth1->rows();
		print "\n\nThe number of rows inserted from ADMDAILYODA are : " . $rows;
		
		if ($rows > 1) {
			print "\n\n Pipeline completed successfully";
		}
		
}

preprocess();