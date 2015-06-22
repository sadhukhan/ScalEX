open IN, $ARGV[0] or die;
open OUT , ">$ARGV[1]" or die;

while($line=<IN>){
	if ($line=~/^\^/){

	}
	elsif($line=~/^\#/){

	}
	elsif($line=~/^\!/){

	}
	elsif($line=~/^ID_REF/){

	}
	else{
		push @out, $line;
	}
}

print OUT @out;
