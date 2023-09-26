#! /usr/bin/perl -w
use strict;

if (@ARGV != 2) {
    die "\nUsage: <infile> <outfile>\n\n";
}

my $infile = shift;
my $outfile = shift;

open (INSTREAM, $infile) or die "Couldn't open file: $infile\n";
open (OUT, ">$outfile") or die "can not open file: $outfile\n";

my $n=0;
my $header=0;
my $line2=0;
my $line3=0;
my $line4=0;
my $index=0;
my $current_line = "";

while ($current_line = <INSTREAM>) {
	chomp ($current_line);
	$n=$n+1;
	if ($current_line=~/^\@([\S\s]+)/ && $n%4==1) {
		$header="\>".$1;
	}
	elsif ($n%4==2 && length($current_line)>=10) {
		print OUT "$header\n$current_line\n";
	}
}
