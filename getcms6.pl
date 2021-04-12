#!/usr/bin/env perl
# Filetype: perl
# Author: AJAY SONI
# Usage: perl getcms6.pl file.OUT [segment list] 
# Description: Print out the FLOWRATE (m3/s) for selected segments over time from output file 

use strict;

#### BEGIN LOAD SES DATA
my $sesfile = shift @ARGV; # Save the file name
my @seglist;
my @times;

while(@ARGV){
push(@seglist,pop(@ARGV));
}

### Open the SES output file for reading
open(SESIN,"$sesfile") || die "unable to open $sesfile for reading\n";

my %data;
### Read Flow data
my $time = 0;
my $nseg = 0;
my $isdet = 0;

do{$_=<SESIN>}until($_ =~/NUMBER OF LINE SEGMENTS\s+(\d+)/); 
	$nseg += $1;
do{$_=<SESIN>}until($_ =~/NUMBER OF VENTILATION SHAFT SECTIONS\s+(\d+)/); 
	$nseg += $1;

##### READ THE DATA FROM THE SES OUTPUT FILE
print STDERR "READING DATA...\n";
while(<SESIN>){

	if($_ =~/^TIME\s+(\d+\.\d+)/){ 
		$time = $1;
		## print STDERR "Getting data for time: $time\n";
		push @times, $time;
		do{$_ = <SESIN>}until($_=~/\s+SYSTEM/);
		if($_ !~/SYSTEM         SENSIBLE/){
			print STDERR "Skipping time: $time becuase it is not a detailed print\n";
			next;
		}

		my $s = 1;
		while($s <= $nseg){             ##    SEC       SEG      SUBSEG  SENS   LAT    TEMP    HR   CMS
			do{$_ = <SESIN>}until($_=~/\s+\d+\s-\s*(\d+)\s-\s+(\d)+\s+\S+\s+\S+\s+\S+\s+\S+\s+(\S+)/);
			$data{$time}{$1}{$2}{T} = $3;
			$s++;


			}
	
	
		}

	
}

#### PRINT IT OUT TO THE A FILE
foreach my $seg (@seglist){
	if($data{$times[0]}{$seg}){

	print STDERR "Generating:$sesfile-$seg.csv\n";
	open(OUT,">$sesfile-$seg.csv") || die "Unable to open $sesfile-$seg.csv for writing: $!\n";

	print OUT ",,Sub-Seg,\n";
	print OUT "Time,Seg,";
	foreach my $sseg (sort {$a <=> $b} keys %{ $data{$times[0]}{$seg} }){
		print OUT "$sseg,";
	}
	print OUT "\n";

	foreach my $t (sort {$a <=> $b} keys %data){
		print OUT "$t,$seg,";
		foreach my $ss (sort {$a <=> $b} keys %{ $data{$t}{$seg} }){
			print OUT "$data{$t}{$seg}{$ss}{T},";
		}
		print OUT "\n";
	}
}
else{print STDERR "Error, requested seg $seg does not exist, skipping\n"; next;}

}

print STDERR "DONE!\n";

