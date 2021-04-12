#!/usr/bin/env perl
# Filetype: perl
# Author: AJAY SONI
# Usage: perl getdbt6.pl file.OUT 
# Description: Extract DBT from output file

use strict;
use warnings;
  
sub main
{
    my $file = $ARGV[0];
    open(FH, $file) or die("File $file not found");
      
    while(my $String = <FH>)
    {
        if($String =~ /DRY-BULB TEMPERATURE   \( DEG C \)/)
        {
            print "$String ";
        }
    }
    close(FH);
}
main();