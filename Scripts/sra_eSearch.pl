
use Bio::DB::EUtilities;
use Bio::Tools::EUtilities;
use Bio::Tools::EUtilities::Summary::Item;

my $factory = Bio::DB::EUtilities->new(-eutil => 'esearch',
                                       -db     => 'sra',
                                       -term   => 'public AND controlled',
                                       -email  => '2023085m@student.gla.ac.uk',
                                       -retmax => 50);

# query terms are mapped; what's the actual query?
print "Query translation: ",$factory->get_query_translation,"\n";

# query hits
print "Count = ",$factory->get_count,"\n";

# UIDs
my @ids = $factory->get_ids;
#my @items = $factory-> get_all_Items;

my $factory = Bio::DB::EUtilities->new(-eutil => 'esummary',
                                       -email => '2023085m@student.gla.ac.uk',
                                       -db    => 'sra',
                                       -id    => \@ids);
#print "ID = ",$factory->get_ids,"\n";
#print "Data = ",$factory->get_all_Items,"\n";

								
while( my $ds = $factory->next_DocSum){
	print "ID: ",$ds->get_id,"\n";

#	print "Item: ",$ds->get_all_Items,"\n";

#parsing revelant data from XML
while (my $item = $ds->next_Item) {
	   print "ID: ", $item->get_id,"\n";	 
           print "Name: ",$item->get_name,"\n";
           print "Data: ",$item->get_content,"\n";
           print "Type: ",$item->get_type,"\n";
#        while (my $listitem = $ds->next_ListItem) {
            # do stuff here...
#            while (my $listitem = $ds->next_Structure) {
                # do stuff here...
#            }
#        }
    }




    # flattened mode
#    while (my $item = $ds->next_Item('flattened'))  {
        # not all Items have content, so need to check...
#        printf("%-20s:%s\n",$item->get_name,$item->get_content)
#          if $item->get_content;
#    }

    print "\n";
}
