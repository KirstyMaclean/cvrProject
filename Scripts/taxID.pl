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
print "NCBI Scientific Name,Common Name,Division,Genus,Species,Subspecies,Taxonomic ID\n";

#for each taxonomic ID search NCBI taxonomic database for Scientific Name.
foreach my $tArray(@tArray)
{
my $id = $tArray;

my $factory = Bio::DB::EUtilities->new(-eutil => 'esummary',
                                       -email => '2023085m@student.gla.ac.uk',
                                       -db    => 'taxonomy',
                                       -id    => $id );
#parse out Scientific Name, Common Name, Division, Genus, Species, Rank and Subspecies#

my $summary=$factory->next_DocSum;

my ($SciName) = $summary->get_contents_by_name('ScientificName');
my ($ComName) = $summary->get_contents_by_name('CommonName'); 
my ($diV) = $summary->get_contents_by_name('Division');
my ($Genus)= $summary->get_contents_by_name('Genus');
my ($Species)= $summary->get_contents_by_name('Species');
#my ($Rank) = $summary->get_contents_by_name('Rank');
my ($Subsp) = $summary->get_contents_by_name('Subsp');



#printing 

print "$SciName,$ComName,$diV,$Genus,$Species,$Subsp,$id\n";
}
