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
print "NCBI Scientific Name\tCommon Name\tLineage\tTaxonomic ID\n";

#for each taxonomic ID search NCBI taxonomic database for Scientific Name.
foreach my $tArray(@tArray)
{
my $id = $tArray;

my $factory = Bio::DB::EUtilities->new(-eutil => 'esummary',
                                       -email => '2023085m@student.gla.ac.uk',
                                       -db    => 'taxonomy',
                                       -id    => $id );
#BROKEN ATM parse out Scientific Name, Common Name and Lineage#
my ($SciName) = $factory->next_DocSum->get_contents_by_name('ScientificName');
my ($ComName) = $factory->next_DocSum->get_contents_by_name('CommonName'); #ERROR MESSAGE: Can't call method "get_contents_by_name" on an undefined value 
my ($Lineage) = $factory->next_DocSum->get_contents_by_name('Lineage');
$Lineage=~s/\t//g; #ensure tabs are ignored in Lineage data 

#printing 
print "$SciName\t$ComName\t$Lineage\t$id\n";
}
