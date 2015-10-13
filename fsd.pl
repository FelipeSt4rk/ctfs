#!/usr/bin/perl

#### OPEN MODULOS ####
use strict;
use Switch;
use warnings;
use IO::Socket::INET;
#### /END MODULOS ####

#### OPEN VARIAVEIS ####
my $result;
my $option = $ARGV[0];
my $domain = $ARGV[1];
#### /END VARIAVEIS ####

sub help {
	print "\n\tCOMMAND \t FUNCTION
	-u --url         Setting target.
	-s --save        Saving result.\n\n
	Examples:\n
	perl fsd.pl -u google.com
	perl fsd.pl --url google.com
	perl fsd.pl -u google.com -s result.txt
	perl fsd.pl -u google.com --save result.txt\n\n";
	exit;
}

sub error {
	print "\nERROR: It is not possible to open the file 'subs.txt'\n\n";
	exit; 
}

sub find {
	if (!$domain) { help(); }

	if ($ARGV[2]) {

		if ( ($ARGV[2] ne "-s") && ($ARGV[2] ne "--save") ) {
			print "\n[+] WARNING: option incompatible. Use '--save' or '-s'.
			\rFollow the example: perl fsd.pl --url google.com --save result.txt\n";
			exit; 
		}

		my $name = $ARGV[3];

		if (!$name) {
			print "\nERROR: For this option set the file name.
			\rFollow the example: perl fsd.pl --url google.com --save result.txt\n\n";
			exit; 
		}

		open ( $result, ">$name");
	}

	#### Regex para remoer https - http - www. se necessario
	$domain =~ s/https:\/\/// || $domain =~ s/http:\/\/// || $domain =~ s/www.// ;

	open ( my $subs,"<subs.txt") or die error(); # Abrindo Lista de sub dominios

	while (<$subs>) { # Criando Loop
		chomp ($_);

		my $find = $_ . $domain; # Concatenando alvo + wordlist

		my $socket = IO::Socket::INET -> new ( # Criando socket
			PeerAddr => $find, # Definindo alvo
			PeerPort => "80",  # Definindo Porta
			Proto    => "tcp", # Definindo Protocolo
			Reuse    => "1",   # Reusando o socket
			Timeout  => "5");  # Tempo maximo de resposta

		if ($socket) {

			my $IpAddr = inet_ntoa (scalar gethostbyname($find));
			print "\n$find $IpAddr\n";

			if ($ARGV[2]) {
				print $result "\n$find $IpAddr\n";
			}
		}
	}

	close $result;
	close $subs;
	exit;
}

switch ($option) {
	case "--url" { find(); }
	case "-u"    { find(); }
	case ""      { help(); }
	else         { help(); }
}