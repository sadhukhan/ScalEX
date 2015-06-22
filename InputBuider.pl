# June 18, 2015

#!/usr/bin/perl
open IN, "GE.dat" or die; #input models.dat

$cntr=1;
$norm_factor=15.3;

while($line=<IN>){
	@line=split /\t/, $line;

	$name=$line[1];
	$gsm=$line[0];
	$gpl=$line[2];
	$dataset=$line[3];
	$name=~s/\s+$//g;
	$gsm=~s/\s+$//g;
	$gpl=~s/\s+$//g;

	$name=~s/\s/\_/g;
	$dataset=~s/\s+$//g;
	chomp $gpl;
	chomp $dataset;

	
	`perl download_from_geo.pl $gsm > $gsm` unless (-e $gsm);
	`perl process_html.pl $gsm $gsm.txt` unless (-e "$gsm.txt");
	`perl download_from_geo.pl $gpl > $gpl` unless (-e $gpl);
	`cp $gpl $gpl.txt` ;

	`perl create_scalex_input.pl $gsm.txt $gpl.txt > $name.input`;
	
	print "$cntr ";

	 #`perl eflux.pl $name.input $norm_factor`;
	#$mf="$name";
	#$out=`matlab -nosplash -nodesktop -r "pathdef; $mf; exit"`;

	#@outall=split /\n/, $out;
	#$biomass=$outall[$#outall];
	#print "$name\t$biomass\n";
	#$biomass=0;

	`mkdir -p $dataset`;
	`cp $name.input $dataset`; 
	
	$cntr=$cntr+1;

}

print "\n";
