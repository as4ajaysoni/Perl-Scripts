#!/usr/bin/env perl
# Filetype: perl
# Author: AJAY SONI
# Usage: perl getline.pl file.OUT <Line number 1> <Line number 2> <Line number 3> 
# Description: Extract specified numbered line from output file
use warnings;
use strict;
   
# Check if line numbers are given as an input
if (@ARGV < 2)
{
    die "usage: pick file_name line_no1 line_no2 ...";
}
   
open FNAME, $ARGV[0] or die "cannot open file";
  
# Exclude the first argument 
# for sorting line numbers
shift (@ARGV); 
my @line_numbers = sort { $a <=> $b } @ARGV; 
   
# Read whole file content into an array 
# and removes new line using chomp()
chomp (my @file = <FNAME>);
   
foreach my $var (@line_numbers) 
{
    if ($var> $#file)
    {
        print "Line number $var is too large\n";
        next;
    }
    print "$file[$var-1]\n";
}
close FNAME;

