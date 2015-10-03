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

print color("bold");

if (!$domain) {
	print color("red"),"\nFollow the example: perl fsd.pl google.com\n\n",color("reset");
	exit; # Finalizando Script
}

if ( ($domain eq "-h") || ($domain eq "--help") ) {
	print "\nYou can use the FindSubDomain in 2 ways:
	\rperl fsd.pl site.com
	\rperl fsd.pl site.com - result.txt\n\n";
	exit;
}

if ($ARGV[1]) {

	if ( ($ARGV[1] ne "-s") && ($ARGV[1 ne "--save") )  {
		print color("red"),"\n[+] WARNING: option incompatible.Use '-'.\n",color("reset");
		exit; # Finalizando Script
	}

	my $name = $ARGV[2];

	if (!$name) {
		print color("red"),"\nERROR: For this option set the file name.
		\rFollor the example: perl fsd.pl > result.txt\n\n",color("reset");
		exit; # Finalizando Script
	}

	open ( $result, ">$name");
}

#### AJUSTES
$domain =~ s/https:\/\/// || $domain =~ s/http:\/\/// || $domain =~ s/www.// ;

sub error { #### SUB ROTINA FOR ERROR
	print color("red"),"\nERROR: It is not possible to open the file 'subs.txt'\n\n",color("reset");
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
		print color("green"),"\n$find $IpAddr\n";

		if ($ARGV[2]) {
			my $IpAddr = inet_ntoa (scalar gethostbyname($find)); # Encontrando IP
			print $result "\n$find $IpAddr\n";
		}

	}
	
}

print color("reset"); # Voltando a cor normal do usuario
close $result;
close $subs; # Fechando wordlist
exit; # Finalizando Script
