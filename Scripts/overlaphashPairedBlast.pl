#! /usr/bin/perl -w
use strict;


if (@ARGV != 3) {
    die "\nUsage: <infile> <outfile>\n\n";
}

my $infile = shift;
my $infile1 = shift;
my $outfile = shift;

open (INSTREAM, $infile) or die "Couldn't open file: $infile\n";
open (INSTREAM1, $infile1) or die "Couldn't open file: $infile1\n";
open (OUT, ">$outfile") or die "can not open file: $outfile\n";

my $n=0;
my $n1=0;
my $i=0;
my $j=0;
my $pos=0;
my $seqname=0;
my $index=0;
my $tRNA=0;
my $current_line = "";
my $current_line1 = "";
my @line="";
my @line1="";
my @s="";
my @s1="";
my %shendure=();
print OUT "queryId\tsubjectId\tpercIdentity\talnLength\tmismatchCount\tgapOpenCount\tqueryStart\tqueryEnd\tsubjectStart\tsubjectEnd\teVal\tbitScore\tqueryId\tsubjectId\tpercIdentity\talnLength\tmismatchCount\tgapOpenCount\tqueryStart\tqueryEnd\tsubjectStart\tsubjectEnd\teVal\tbitScore\n";
while ($current_line1 = <INSTREAM1>) {
	chomp ($current_line1);
	@s1=split(/\//, $current_line1);
	$seqname=$s1[0];
	@s1=split(/\t/, $current_line1);
	$tRNA=$s1[1];
	$pos=$seqname."\t".$tRNA;
	$shendure{$pos} = $current_line1;
}

while ($current_line = <INSTREAM>) {
	chomp ($current_line);
	@s=split(/\//, $current_line);
        my $seqname=$s[0];
	@s=split(/\t/, $current_line);
	$tRNA=$s[1];
	$index=$seqname."\t".$tRNA;
	if (exists $shendure{"$index"}) {
		@s1=split(/\t/, $shendure{$index});
		if ($s[3]>=20 && $s1[3]>=20) {
			print OUT "$current_line\t$shendure{$index}\n";
		}
		elsif ($s[8] ne $s1[9]) {
			print OUT "$current_line\t$shendure{$index}\n"
		}
		elsif ($s[9] ne $s1[8]) {
			print OUT "$current_line\t$shendure{$index}\n"
		}

	}
}
