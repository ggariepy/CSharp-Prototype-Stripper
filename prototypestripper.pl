#!/usr/bin/perl
=pod

Simple Perl script designed to strip the function prototypes from a C# class
and write them to a separate output file.  Written to facilitate a port of
a group of C# classes from SQL Server to MongoDB.  Free to use/abuse/redistribute
as you see fit, this is hereby declared to be public domain software, no license
required, attribution appreciated.

Modification History
26-MAY-2016: geoff.gariepy@gmail.com: Creation

=cut

use 5.018;

my $inputfile = $ARGV[0];
my $outputfile = $ARGV[1];

if ($inputfile eq $outputfile || length($inputfile) == 0 || length($outputfile) == 0) {

	die ("Usage:\nprototypestripper.pl inputfile outputfile\n");
}

open my $IFH, '<', $inputfile;

my @lines = <$IFH>;

close $IFH;

open my $OFH, '>', $outputfile;

my $counter = 0;
my @prototypelines;

foreach my $line (@lines) {
	$counter++;
	if ($line =~ /^(\s*)(public|private)\s*(\w+|\s|\[|\]|<|>)+(\(.*\))/ && $line !~ /\bas\b|=|\bif\b|struct|enum|class/) {
		#say "$counter\t$line$1\{\n$1\}\n";
		push @prototypelines, $line;
	}
}

foreach my $prototype (sort @prototypelines) {
	$prototype =~ /^(\s*)/;
	say $OFH "$prototype" . $1 . "{\n" . $1 . "}\n";
}

close $OFH;