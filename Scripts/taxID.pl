use strict;
use warnings;
use Bio::DB::EUtilities;
#creating array
my @tArray;

#opening text file of Taxonomic IDs
open(my $fh, "<", "TaxID.txt")
    or die "Failed to open file: $!\n";
while(<$fh>) { 
    chomp; 
    push @tArray, $_;
} 
close $fh;

#printing the header for text file
print "NCBI Scientific Name\tTaxonomic ID\n";

#for each taxonomic ID search NCBI taxonomic database for Scientific Name.
foreach my $tArray(@tArray)
{
my $id = $tArray;

my $factory = Bio::DB::EUtilities->new(-eutil => 'esummary',
                                       -email => '2023085m@student.gla.ac.uk',
                                       -db    => 'taxonomy',
                                       -id    => $id );

my ($name) = $factory->next_DocSum->get_contents_by_name('ScientificName');
#printing name and ID
print "$name\t$id\n";
}
