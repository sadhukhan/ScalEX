#use warnings;

open GSM, "$ARGV[0]" or die;
open GPL, "$ARGV[1]" or die;

@gplfile=<GPL>;
$index=0;
for($i=0; $i<=$#gplfile;$i++){
	if($gplfile[$i] =~ /^\#Gene\sSymbol/){
		$index=$i-1;
	}
}

#print "index: $index\n";

for($i=0; $i<=$#gplfile;$i++){
	
$line=$gplfile[$i];
	@line=split /\t/, $line;
	$id=$line[0];
	$genename=$line[$index];

	chomp $genename;
	$map{$id}=$genename;

}

while($line=<GSM>){
chomp $line;
	@line=split /\t/, $line;
	print "\t$map{$line[0]}\t$line[1]\n";
}
