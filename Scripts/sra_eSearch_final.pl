use Bio::DB::EUtilities;
use Bio::Tools::EUtilities;
use Bio::Tools::EUtilities::Summary::Item;

my $factory = Bio::DB::EUtilities->new(-eutil => 'esearch',
                                       -db     => 'sra',
                                       -term   => 'public OR controlled',
                                       -email  => '2023085m@student.gla.ac.uk',
					-usehistory => 'y');

# query terms are mapped; what's the actual query?
print "Query translation: ",$factory->get_query_translation,"\n";

# query hits
print "Count = ",$factory->get_count,"\n";
my $count = $factory->get_count;

#get history from queue
my $hist = $factory->next_History || die 'No history data returned';


my $factory = Bio::DB::EUtilities->new(-eutil => 'esummary',
                                       -email => '2023085m@student.gla.ac.uk',
                                       -db    => 'sra',
					-history => $hist);

my $retry = 0; my ($retmax, $retstart) = (500,0);
while ($retstart < $count) {
    $factory->set_parameters(-retmax => $retmax,
                             -retstart => $retstart);
    eval{
        $factory->get_Response(-cb =>
            sub {my ($data) = @_; print $out $data} );
    };
    if ($@) {
        die "Server error: $@.  Try again later" if $retry == 5;
        print STDERR "Server error, redo #$retry\n";
        $retry++;
    }
	print "Retrieved $retstart";
    $retstart += $retmax;


close $out;

while (my $ds = $factory->next_DocSum){
  my ($id,$name,$design,$platform,$model,$bases,$date,$des,$study);
  $id=$ds->get_id;
  while (my $item = $ds->next_Item) {
     $name=$item->get_name;
     my $data=$item->get_content;

if($data=~/\<Summary><Title\>(.+)\<\/Title\>\<Platform instrument_model\=\"(.+)\"\>(.+)\<\/Platform\>\<Statistics total_runs\=\"(.+)\" total_spots\=\"(.+)\" total_bases\=\"(.+)\" total_size/){     
  $design=$1;
      $model=$2;
       $platform=$3;
	$bases=$6;
}      
if ($name="CreateDate"){
	$date=$item->get_content;
}

if($data=~/\<Study acc\=\"(.+)\" name\=\"(.+)\"\/\>\<Organism taxid/){
	$study=$1;
	$des=$2;
		
}	
   }
print "\nId: $id\nDesign: $design\nPlatform: $platform\nModel: $model\nNumber of Bases: $bases\nDate: $date\nDescription: $des\nStudy Accession: $study\n";

}
}
