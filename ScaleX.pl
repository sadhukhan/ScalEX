# Scale-X main code #
# PriyankaSadhukhan: 20Jun2015

#use warnings;
open IN, "dataset" or die;
open RES, ">> ab_results" or die;

#print the date
@months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
@weekDays = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
$year = 1900 + $yearOffset;
$theTime = "$hour:$minute:$second, $weekDays[$dayOfWeek] $months[$month] $dayOfMonth, $year";
print RES "*** $theTime ***\n"; 


while($line=<IN>){
	
	@line=split /\t/, $line;
	$model=$line[0];
	$NF=$line[1];
	chomp $NF;
	chomp $model;
	foreach $a((1,10)){#0.25, 0.5, 0.75, 1.0
print " $a:";
		foreach $b ((0.83)){#0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.83, 0.875, 1
			if ($NF > 0 && -f $model){
				`perl eflux.pl $model 1 $a $b >>ab_results` ;
			}
			else{
				print "Error: model: $model or NF: $NF\n"
			}
print ":$b**";	
		}

	}


# prepare Error.log
	

}
print RES "\t\t*** ** *** ** ***\n\n";
