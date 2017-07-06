use Bio::DB::EUtilities;
use Bio::Tools::EUtilities;
use Bio::Tools::EUtilities::Summary::Item;

my $factory = Bio::DB::EUtilities->new(-eutil => 'esearch',
                                       -db     => 'sra',
                                       -term   => 'public OR controlled',
                                       -email  => '2023085m@student.gla.ac.uk',
					-usehistory => 'y');

# query terms are mapped; what's the actual query?
#print "Query translation: ",$factory->get_query_translation,"\n";

# query hits
#print "Count = ",$factory->get_count,"\n";
my $count = $factory->get_count;

#get history from queue
my $hist = $factory->next_History || die 'No history data returned';


my $factory = Bio::DB::EUtilities->new(-eutil => 'esummary',
                                       -email => '2023085m@student.gla.ac.uk',
                                       -db    => 'sra',
					-history => $hist);
#print "Id\tStudyAcc\tOrganism\tDate\tUpdateDate\tPlatform\tModel\tBases\tDesign\tDescription\n";
my $retry = 0; my ($retmax, $retstart) = (7000,0);
while ($retstart < $count) {
    $factory->set_parameters(-retmax => $retmax,
                             -retstart => $retstart);
    eval{
        $factory->get_Response(-cb =>
            sub {my ($data) = @_; print $out $data} );
    };
    if ($@) {
        die "Server error: $@.  Try again later" if $retry == 5;
#        print STDERR "Server error, redo #$retry\n";
        $retry++;
    }
#	print "Retrieved $retstart";
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
	$design=~s/\t//g;
      $model=$2;
       $platform=$3;
	$platform=~s/\t//g;
	$bases=$6;
}      
if ($name="CreateDate"){
	$date=$item->get_content;
	$date1=$item->get_content;
}
if($data=~/\<Submitter acc\=\"(.+)\" center_name\=\"(.+)\" contact_name\=\"(.+)\" lab_name\=\"(.+)\"\/><Experiment/)
{
 $submitter=$1;
 $submitter=~s/\t//g;
 $center=$2;
 $center=~s/\t//g;
 $contact=$3;
 $contact=~s/\t//g;
 $lab=$4;
 $lab=~s/\t//g;
}
if($data=~/\<Study acc\=\"(.+)\" name\=\"(.+)\"\/\>\<Organism taxid\=\"(.+)\" CommonName\=\"(.+)\"\/\>\<Sample/){
	$study=$1;
	$study=~s/\t//g;
	$des=$2;
	$des=~s/\t//g;
	$taxId=$3;
	$taxId=~s/\t//g;
	$organ=$4;
	$organ=~s/\t//g;		
}	
#if ($data=~/\<LIBRARY_NAME\>(.+)\</LIBRARY_NAME>\<LIBRARY_STRATEGY\>(.+)\</LIBRARY_STRATEGY>\<LIBRARY_SOURCE\>(.+)\</LIBRARY_SOURCE>\<LIBRARY_SELECTION\>(.+)\</LIBRARY_SELECTION>\<LIBRARY_LAYOUT/)
#{
#$libName=$1;
#$libStrat=$2;
#$libSelect=$3;

#}
if($data=~/\<Bioproject\>(.+)\<\/Bioproject\>\<Biosample\>(.+)\<\/Biosample>/)
{
$bioProj=$1;
$bioSample=$2;
}
} 
#print "$id\t$study\t$organ\t$date\t$date1\t$platform\t$model\t$bases\t$design\t$des\n";
print "$bioProject\t$bioSample\t$submitter\t$lab";


}

}
