#! /usr/bin/perl -w

# BUG REPORT TO: duan@mit.edu

use strict;

if (@ARGV != 2) {
    die "\nUsage: <infile> <outfile>\n\n";
}

my $infile = shift;
my $outfile = shift;

open (INSTREAM, $infile) or die "Couldn't open file: $infile\n";
open (OUT, ">$outfile") or die "can not open file: $outfile\n";

my $current_line = "";
my $n=0;

while ($current_line = <INSTREAM>) {
    chomp ($current_line);
    $n=$n+1;
    if ($n%4==2) {
    	$current_line =~ tr/ACTGactg/TGACtgac/;
   	 print OUT  scalar reverse("$current_line"), "\n"; 
    }
    else{
       	 print OUT "$current_line\n";
    }
    
}

