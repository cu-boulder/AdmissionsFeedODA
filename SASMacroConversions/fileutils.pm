package fileutils;

use warnings;
use strict;

#use Config::Inifiles;

sub sqlfromfile {
	
	open my $file, '<', shift or die "unable to open file\n";
	local $/;
	return <$file>;
	
}

1;

