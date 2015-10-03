#!/usr/bin/perl

#### OPEN MODULOS ####
use strict;
use warnings;
use Term::ANSIColor;
use IO::Socket::INET;
#### /END MODULOS ####

#### OPEN VARIAVEIS ####
my $result;
my $domain = $ARGV[0];
#### /END VARIAVEIS ####

sub help {
	print color("bold"),"\nYou can use the FindSubDomain in 3 ways:
	\rperl fsd.pl github.com
	\rperl fsd.pl github.com --save result.txt
	\rperl fsd.pl github.com -s result.txt\n\n",color("reset");
	exit;
}

if (!$domain) {
	return help();
}

if ( ($domain eq "-h") || ($domain eq "--help") ) {
	return help();
}

if ($ARGV[1]) {

	if ( ($ARGV[1] ne "-s") && ($ARGV[1] ne "--save") ) {
		print color("bold red"),"\n[+] WARNING: option incompatible.Use '-'.\n",color("reset");
		exit; # Finalizando Script
	}

	my $name = $ARGV[2];

	if (!$name) {
		print color("bold red"),"\nERROR: For this option set the file name.
		\rFollor the example: perl fsd.pl > result.txt\n\n",color("reset");
		exit; # Finalizando Script
	}

	open ( $result, ">$name");
}

#### AJUSTES
$domain =~ s/https:\/\/// || $domain =~ s/http:\/\/// || $domain =~ s/www.// ;

sub error { #### SUB ROTINA FOR ERROR
	print color("bold red"),"\nERROR: It is not possible to open the file 'subs.txt'\n\n",color("reset");
	exit; # Finalizando Script
}

open (my $subs,"<subs.txt") or die error(); # Abrindo Lista de sub dominios

while (<$subs>) { # Criando Loop
	chomp ($_);

	my $find = $_ . $domain; # Concatenando alvo + wordlist

	my $socket = IO::Socket::INET -> new ( # Criando socket
		PeerAddr => $find, # Definindo alvo
		PeerPort => "80",  # Definindo Porta
		Proto    => "tcp", # Definindo Protocolo
		Reuse    => "1",   # Reusando o socket
		Timeout  => "5");  # Tempo maximo de resposta

	if ($socket) { # Imprimindo resposta
		my $IpAddr = inet_ntoa (scalar gethostbyname($find)); # Encontrando IP
		print color("bold green"),"\n$find $IpAddr\n",color("reset");

		if ($ARGV[2]) {
			my $IpAddr = inet_ntoa (scalar gethostbyname($find)); # Encontrando IP
			print $result "\n$find $IpAddr\n";
		}

	}
	
}

close $result;
close $subs; # Fechando wordlist
exit; # Finalizando Script
