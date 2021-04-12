#!/usr/bin/env perl
# Filetype: perl
# Author: AJAY SONI
# Usage: perl getec6.pl file.OUT 
# Description: Extract ECZ data from output file
use strict;
use warnings;
  
sub main
{
    my $file = $ARGV[0];
    open(FH, $file) or die("File $file not found");
      
    while(my $String = <FH>)
    {
        if($String =~ / ZONE TOTAL/)
        {
            print "$String ";
        }
    }
    close(FH);
}
main();