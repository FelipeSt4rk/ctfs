#!/usr/bin/perl

use strict;
use warnings;
use IO::Socket::INET;

my $domain = $ARGV[0];

if (!$domain) {
	print "\nFollow the example: perl fsd.pl google.com\n\n";
	exit;
}

$domain =~ s/https:\/\/// || $domain =~ s/http:\/\/// || $domain =~ s/www.// ;

sub error {
	print "\nERROR: It is not possible to open the file 'subs.txt'\n\n";
	exit;
}

open (my $subs,"<subs.txt") or die error();

while (<$subs>) {
	chomp ($_);

	my $find = $_ . $domain;

	my $socket = IO::Socket::INET -> new (
		PeerAddr => $find,
		PeerPort => "80",
		Proto    => "tcp",
		Reuse    => "1",
		Timeout  => "5");

	if ($socket) {
		my $IpAddr = inet_ntoa (scalar gethostbyname($find));
		print "\n$find $IpAddr\n";
	}
	
}
close $subs;
exit;
