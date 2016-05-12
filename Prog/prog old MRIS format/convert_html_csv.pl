# Convert HTML files to CSV
# by David Price
# December 20, 2010



@files = <D:/DCData/Libraries/MRIS/Data/Zip/*.xls>;
foreach $file (@files) {

print $file . "\n";

open (zipdata, $file);

open(outcsv, ">" . $file . ".csv");

$output = "";

while($line = <zipdata>)
	{
		# remove ALL whitespace
		#$line =~ s/^\s+//;
		#$line =~ s/\s+$//;
		$line =~ s/\s//g;
		
		
		# strip HTML tags
		($stripline = $line) =~ s/<[^>]*>//gs;
		
		# strip commas
		($stripline = $stripline) =~ s/,//gs;
		
		# strip nbsp
		($stripline = $stripline) =~ s/&nbsp;//gs;
		
		$stripline =~ s/^\s+//;
		$stripline =~ s/\s+$//;
		
		if ( $line =~ /<\/TR>/i )
		{
			$output = $output . "\n"
		}
		elsif ( $line =~ /<\/TD>/i )
		{
			$output = $output . ","
		}
		elsif ( $stripline =~ /\S/ )
		{
			$output = $output . $stripline
		}
				
	}
	
print outcsv $output;
	
	close (outcsv);
	close(zipdata);
	

 } 