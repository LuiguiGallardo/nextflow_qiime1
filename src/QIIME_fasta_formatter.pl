#!/bin/usr/perl
# Copyright George Watts, University of Arizona 2013.
# Bugs? Suggestions? contact: gwatts@email.arizona.edu
# This script is free to use for non-profit purposes.

use strict;
use warnings;
use Getopt::Long;

my $help = '';
my $subdirectory = '';
GetOptions ("help|h|man|?" => \$help, "i=s" => \$subdirectory) or die "Incorrect usage. Help on using this script is available using the option -h or --help \n";

my $help_text = "

PURPOSE:        Re-format Ion Torrent generated .fasta files to be QIIME ready.

Input:          required: -i <directory>
                All .fasta files in the directory provided with the -i option will be processed.
                Reads within the .fasta files should already be quality and primer trimmed.
				

                Filenames must start with a numeric unique sample identifier and end with \".fasta\"

                For example, if IonXpress barcode 17 was used with a sample containing Ion Torrent
                reads from 16s rRNA regions V1 and V6, a workable filename would be: \"17.V1V6.fasta\"

                While this script was written with Ion Torrent PGM data in mind, any .fasta file will
                work as long as the filename is in the correct format described above.

Output:         A file named: \"OriginalFilename.fna\".
                Using the example above, the output file  would be: \"17.V1V6.fna\"

                The headers in the output .fna file(s) will be reformatted for QIIME.
                Most importantly, the new headers will start with:
                \"numeric_unique_sample_identifier underscore unique_read_number\".
                followed by whatever the original header was, followed by QIIME optional header
                information.

                Using the example above, the first read in 17.V1V6.fasta would have a Ion Torrent
                unqiue read header like:
                \">M215P:00308:00510\"

                The new header for this read in the output file 17.V1V6.fna will be QIIME compatible:
                \"17.V1V3V6_0 M215P:00308:00510 orig_bc=NA new_bc=NA bc_diffs=0\"

                Multiple .fna output files may then be concatenated to yield a .fna file for analysis in
                QIIME in which each sample and read has a unique ID.

Usage:          \"perl QIIMEfastaFormatter.pl -i <directory>\" where directory contains .fasta
                files to be formatted.
	
                When script is complete, use the cat command to concatenate all the output
                .fna files together into a single file for analysis with QIIME:
                \"cat *.fna > all.fna\"

                The resulting all.fna file can be used to enter the QIIME pipeline at
                pick_otus_through_otu_table.py; see qiime.org/tutorials/tutorial.html
                for information on using QIIME


";

if ($help) {print $help_text; exit;}

my @fastafilepaths = '';
my $path = '';

if ($subdirectory eq '') {
		print "\nError: input directory must be indicated with \"-i <directory>\".\nUsage: \"perl QIIMEfastaformatter -i <directory>\"\nSee more help with the -h option.\nExiting.\n"; exit;
}	
else {
	chomp $subdirectory;
	my $path = '';
	if ( (-d $subdirectory) && (-e $subdirectory) ) {
		chomp (my $pwd = `pwd`); 
		$path = "$pwd\/$subdirectory";
		@fastafilepaths = <$path/*.fasta>;
		if ($#fastafilepaths == -1) {
		print "Directory \"$subdirectory\" is empty. Exiting...\n"; exit;
		}
 	} else {
		print "Directory \"$subdirectory\" does not exist or is not a directory. Exiting...\n"; exit;
	}
}


for my $fastafilepath (@fastafilepaths) {
	open (FILE, "$fastafilepath") or die "Couldn't open: $!";
	local $/ = undef;
	my $input = <FILE>;
	close (FILE);
	#replace > "carrot" of fasta headers with %%%
	$input =~s/\>/\%%%/g;
	$input =~s/\r//g;
	#split $input into @paired_headers_and_sequences so each element contains a header and related sequence
	my @paired_headers_and_sequences = split(/\%%%/, $input);
	#get rid of the empty element  because of split on %%% which was at the start of $input
	shift (@paired_headers_and_sequences);
	#strip the .fasta suffix from filename
	my @filepath = split(/\//,$fastafilepath);
	my $output_filename = $filepath[-1];
	$output_filename =~ s/\.fasta//;
	pop(@filepath);
	my $output_path = join ("/", @filepath);
	open (OUT, ">$output_path\/$output_filename.fna") or die "Couldn't open: $!"; 
	my $headers_processed = 0;

	foreach my $head_and_seq (@paired_headers_and_sequences) { 
		$head_and_seq=~ s/\n/@@##@@##@@/g;
		#separate header from sequence into @tmp[0] and @tmp[1]
		my @headers_and_sequences = split(/@@##@@##@@/, $head_and_seq, 2);
		#make new header compatible with QIIME:
		my $header = ">$output_filename\_$headers_processed $headers_and_sequences[0] orig_bc=NA new_bc=NA bc_diffs=0";
		my $seq = $headers_and_sequences[1];
		$seq =~s/\r|\n|@@##@@##@@//g;
		#$seq =~s/\n//g;
		#$seq =~s/@@##@@##@@//g;
		print OUT "$header\n$seq\n";
		$headers_processed++;
	}

close (OUT);
print	"File processed: $fastafilepath\nNumber of sequences processed = $headers_processed\nOutput file: $output_filename.fna\n\n";
}
print "Done.\n"
