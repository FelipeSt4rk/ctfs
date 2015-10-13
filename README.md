# Find Sub Domain with Perl

##### MODULES THAT WILL BE REQUIRED TO USE THE SCRIPT

1. strict
2. warnings
3. IO::Socket::INET
4. Term::ANSIColor

####Installing:

    git clone https://github.com/FelipeStr4rk/FindSubDomain
    cd FindSubDomain
    cpan install  strict warnings Switch IO::Socket::INET

####Commands:

	COMMAND          FUNCTION
	-u --url         Setting target.
	-s --save        Saving result.

	Examples:
	perl fsd.pl -u google.com
	perl fsd.pl --url google.com
	perl fsd.pl -u google.com -s result.txt
	perl fsd.pl -u google.com --save result.txt
