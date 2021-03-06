

package emailutils;

use warnings;
use strict;
use MIME::Lite;
#use Config::IniFiles;

my $emailconfig = Config::IniFiles->new(
	-file => "C:/Users/<required-path-here>/emailcredentials.ini"
);

sub send_email {
	
	my ($arg1, $arg2) = @_;
	
	my $from = $emailconfig->val('email','from');
	my $to = $emailconfig->val('email','to');
	my $cc = $emailconfig->val('email','cc');
	my $subject = $arg1;#$emailconfig->val('email','subject');
	my $message = $arg2;#$emailconfig->val('email','message');
	my $signature = $emailconfig->val('email','signature');
	
	my $emailmessage = MIME::Lite->new(
		From => $from,
		To => $to,
		Cc => $cc,
		Subject => $subject,
		Type => 'multipart/mixed'
	);
	
	$emailmessage->send(
		'smtp',
		"smtp.mailtrap.io",
		#Type => $emailconfig->val('emailserver','type'),
		#Server => $emailconfig->val('emailserver','server'),
		Port => $emailconfig->val('emailserver','port'),
		Hello => $emailconfig->val('emailserver','hello'),
		AuthUser => $emailconfig->val('emailserver','authuser'),
		AuthPass => $emailconfig->val('emailserver','authpass')
	);
}

1;