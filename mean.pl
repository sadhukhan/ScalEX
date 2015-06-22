#use warnings;
use List::Util qw[min max];
my %max_val;
my %ind_constraint;
my %constraint;

foreach $file(<*.input>){
	open FI, $file or print "couldn't open $file\n";
	while($line=<FI>){
		@line=split /\t/, $line;
		$id=$line[1];
		$val=$line[2];
		chomp $val;
		$ind_constraint{$file}->{$id}=$val;
		push @{$constraint{$id}}, $val;
	}
	close(FI);
}

foreach $id (keys %constraint){
	$mean_val{$id}=&average( \@{$constraint{$id}});
	print "\t$id\t$mean_val{$id}\n";
}

sub average{
        my($data) = @_;
        if (not @$data) {
                die("Empty array\n");
        }
        my $total = 0;
        foreach (@$data) {
                $total += $_;
        }
        my $average = $total / @$data;
        return $average;
}
