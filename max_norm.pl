# code for max normalization of GE intensity
# PriyankaSadhukhan : 19Jun2015
# Modified: PriyankaSadhukhan: 20Junb2015

#use warnings;

open PLATFORM, "$ARGV[0]" or die;
open SAMPLE, "$ARGV[1]" or die;

@gplfile=<PLATFORM>;
@sample=<SAMPLE>;

$index=0;
$gpltablestart=0;
for($i=0; $i<=$#gplfile;$i++){
	if($gplfile[$i] =~ /^\#Gene\sSymbol/){
		$index=$i-1;
	}
	if($gplfile[$i] =~ /^\!platform_table_begin/){
		$gpltablestart=$i+2;
	}
}

my %GE;
for($i=$gpltablestart; $i<$#gplfile;$i++){
	$line=$gplfile[$i];
	@line=split /\t/, $line;
	$genename=$line[$index];
	chomp $genename;
	@GE{$genename} = 0;
}

for($i=0; $i<=$#sample; $i++){
	chomp $sample[$i];
	@line=split(/\t/, $sample[$i]);
	@GE{$line[1]}=$line[2];
}
	

my $max_value = -1000;
while ((my $gene, my $intensity) = each %GE) {
  if ($intensity > $max_value) {
    $max_value = $intensity;
  }
}

my %GE_maxnorm;
foreach my $gene( keys %GE ){
	if($GE{$gene} == 0){
		$GE_maxnorm{$gene}=$GE{$gene};}
	else{
		$x=$GE{$gene};
		$GE_maxnorm{$gene}=($x/$max_value);
	}
  print "$gene\t$GE_maxnorm{$gene}\n";
}
