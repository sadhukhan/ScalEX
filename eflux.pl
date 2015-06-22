=head
Perl implementation of e-flux method
perl eflux.pl inputfile.txt
# Files needed to be present in the same direcory:

	1. gene_intensity file: 
		this file should be the first argument to the program

		A sample GSE file: 
		#serial_no	gene_name	intensity
		3	 A1BG	5.92
		4	 A1CF	5.173333333
		5	 A2BP1	5.83
		6	 A2LD1	5.593333333
		7	 A2M	4.433333333
		8	 A2ML1	4.213333333
		9	 A4GALT	5.766666667
		10	 A4GNT	4.023333333
		11	 AAA1	4.393333333
		12	 AAAS	8.653333333
		13	 AACS	8.466666667
		14	 AACSL	3.293333333
		15	 AADAC	7.813333333
	2. recon.xml
	3. gene_names.pm

=cut

=head
Blood models: Author Normalized
Tissue models: Our normalized

for i in *.input; do perl eflux.pl $i NF; done
where, NF is corresponding Normalization factor for each model

=cut



# modules required: 
use File::Spec;
use LibSBML;
#use warnings;
use List::Util qw[min max];

# files:
require 'gene_names.pm' or die;
open GI, $ARGV[0] or die;
$mfname=$ARGV[0];
$mfname=~s/input/m/g;

$oname=$ARGV[0]."_".$ARGV[2]."_".$ARGV[3]."_data.txt";
$oname=~s/\.input//g;


$mfname=$oname;
$mfname=~s/\_data\.txt//g;
$mfname=~s/\.//g;
$mfname.=".m";

# output files: 
open OUT, ">$oname" or die;
open MAT, ">$mfname" or die;
$pfname=$mfname;
$pfname=~s/\.m/\.png/g;

#model = changeRxnBounds(model,'EX_o2(e)',-57,'b');

#print MAT "load('recon _minimal.mat');\ninitCobraToolbox;\nchangeCobraSolver ('tomlab_cplex');\nminimal;\nmodel = changeObjective(model, 'biomass_reaction');\nsolutionF1=optimizeCbModel(model);\n";

print MAT "load('recon_minimal.mat');\ninitCobraToolbox;\nchangeCobraSolver ('tomlab_cplex');\nmodel = changeObjective(model, 'biomass_mm_1_no_glygln');\nsolutionF1=optimizeCbModel(model);\n";


# things needed to be declared before calling of the subroutine 'get_constraints'
my %sub_ref=();
$sub_ref{"or"}=\&addition;
$sub_ref{"and"}=\&minim;
$sub_ref{""}=\&first_one;
sub minim{
	return min(@_);
}
sub first_one{
	return $_[0];
}
sub addition{
	$num=0;
	map{$num+=$_}@_;
	return $num;
}
my %intensity;

# part where gene intensity file is read
@ge=<GI>;
foreach $line(@ge){
	$line=~s/\"//g;
	@line=split /\s+/, $line;
	$gene=$line[1];
	@gene=split /\/\/\//, $gene;
	map{$_=~s/\s//g}@gene;
	$temp=$line[2];
	chomp $temp;
	map{$intensity{$_}=$temp;}@gene;
}
# so now intensiy of each gene is in $intensity{$gene_name}

my $file     = File::Spec->rel2abs("recon.xml");
my $rd       = new LibSBML::SBMLReader;
my $document = $rd->readSBML($file);
my $errors   = $document->getNumErrors();
if ($errors > 0) {
	$document->printErrors();
	print OUT "Errors while reading $file\n";
	die "Errors while reading $file";
}
my $model = $document->getModel() || die "No Model found in $file";
my $list= $model->getListOfReactions();
my $max_count=$model->getNumReactions();

for ($count=0; $count<$max_count;$count++){

	my $reaction= $list->get($count);
	my $notes=$reaction->getNotes();
	my $name=$reaction->getName();
	my $id=$reaction->getId();
my $notes_in_string="";
	$notes_in_string=$notes->convertXMLNodeToString() if $notes;
	my $isReversible=$reaction->getReversible(); 	

	if($notes_in_string && $notes_in_string =~/GENE ASSOCIATION\:([^\<]+)\</){
	    $gene_association=$1;
	}

	#changes that need to be done in id so that it matches id in recon.mat
	$id=~s/^R\_//g;
	$id=~s/\n//g;
	$id=~s/\_LPAREN\_/\(/g;
	$id=~s/\_RPAREN\_/\)/g;
	#$id=~s/\_L\(/\-L\(/g;##############
	#$id=~s/\_D\(/\-D\(/g;##############
	#$id=~s/L\-/L\_/g;##############
	#$id=~s/D\-/D\_/g;##############

	$id=~s/24_COMMA_25VITD2Hm/24,25VITD2Hm/g;
	$id=~s/24_COMMA_25VITD3Hm/24,25VITD3Hm/g;
	$id=~s/ACP1_FMN/ACP1(FMN)/g;
	$id=~s/D_LACt2/D-LACt2/g;
	$id=~s/D_LACtm/D-LACtm/g;
	$id=~s/GGH_10FTHF5GLUe/GGH-10FTHF5GLUe/g;
	$id=~s/GGH_0FTHF5GLUe/GGH-10FTHF5GLUe/g;
	$id=~s/GGH_10FTHF5GLUl/GGH-10FTHF5GLUl/g;
	$id=~s/GGH_10FTHF5GLUl/GGH-10FTHF5GLUl/g;
	$id=~s/GGH_10FTHF6GLUe/GGH-10FTHF6GLUe/g;
	$id=~s/GGH_10FTHF6GLUe/GGH-10FTHF6GLUe/g;
	$id=~s/GGH_10FTHF6GLUl/GGH-10FTHF6GLUl/g;
	$id=~s/GGH_10FTHF6GLUl/GGH-10FTHF6GLUl/g;
	$id=~s/GGH_10FTHF7GLUe/GGH-10FTHF7GLUe/g;
	$id=~s/GGH_10FTHF7GLUe/GGH-10FTHF7GLUe/g;
	$id=~s/GGH_10FTHF7GLUl/GGH-10FTHF7GLUl/g;
	$id=~s/GGH_10FTHF7GLUl/GGH-10FTHF7GLUl/g;
	$id=~s/GGH_5DHFe/GGH-5DHFe/g;
	$id=~s/GGH_5DHFe/GGH-5DHFe/g;
	$id=~s/GGH_5DHFl/GGH-5DHFl/g;
	$id=~s/GGH_5DHFl/GGH-5DHFl/g;
	$id=~s/GGH_5THFe/GGH-5THFe/g;
	$id=~s/GGH_5THFe/GGH-5THFe/g;
	$id=~s/GGH_5THFl/GGH-5THFl/g;
	$id=~s/GGH_5THFl/GGH-5THFl/g;
	$id=~s/GGH_6DHFe/GGH-6DHFe/g;
	$id=~s/GGH_6DHFe/GGH-6DHFe/g;
	$id=~s/GGH_6DHFl/GGH-6DHFl/g;
	$id=~s/GGH_6DHFl/GGH-6DHFl/g;
	$id=~s/GGH_6THFe/GGH-6THFe/g;
	$id=~s/GGH_6THFe/GGH-6THFe/g;
	$id=~s/GGH_6THFl/GGH-6THFl/g;
	$id=~s/GGH_6THFl/GGH-6THFl/g;
	$id=~s/GGH_7DHFe/GGH-7DHFe/g;
	$id=~s/GGH_7DHFe/GGH-7DHFe/g;
	$id=~s/GGH_7DHFl/GGH-7DHFl/g;
	$id=~s/GGH_7DHFl/GGH-7DHFl/g;
	$id=~s/GGH_7THFe/GGH-7THFe/g;
	$id=~s/GGH_7THFe/GGH-7THFe/g;
	$id=~s/GGH_7THFl/GGH-7THFl/g;
	$id=~s/GGH_7THFl/GGH-7THFl/g;
	$id=~s/H6_APOS_ETer/H6''ETer/g;
	$id=~s/H7_APOS_ETer/H7''ETer/g;
	$id=~s/L_LACt2r/L-LACt2r/g;
	$id=~s/L_LACt2r/L-LACt2r/g;
	$id=~s/L_LACtcm/L-LACtcm/g;
	$id=~s/L_LACtcm/L-LACtcm/g;
	$id=~s/L_LACtm/L-LACtm/g;
	$id=~s/L_LACtm/L-LACtm/g;
	#$id=~s/L\-/L\_/g;##############
	#$id=~s/D\-/D\_/g;##############

	#$id=~s/\-/\_/g;
	$id=~s/\_$//g;

	$reaction_intensity=&get_constraints($gene_association);

	unless( $reaction_intensity eq "" || $reaction_intensity == 0){
		$new_a=$ARGV[2];
		$new_b=$ARGV[3];
		$reaction_intensity=sprintf "%.2F", $new_a*(($reaction_intensity/$ARGV[1])**$new_b);
		$reverse_intensity=-1*$reaction_intensity if $isReversible ==1;
		$reverse_intensity=0 if $isReversible ==0;
		if($reaction_intensity >= $reverse_intensity){
			print OUT "$id\t$name\t$reaction_intensity\n";
			#print "$id\n";
			print MAT "model = changeRxnBounds(model,\'$id\',$reaction_intensity,'u');\nmodel = changeRxnBounds(model,\'$id\',$reverse_intensity,'l');\n";
		}
	}
	$reaction_intensity="";
	$reverse_intensity="";


}
#print MAT "solutionF2=optimizeCbModel(model);\nbiomass=solutionF2.f;\nbiomass\nf=figure;\n[robustness_x, robustness_y]=robustnessAnalysis(model, 'EX_o2(e)');\nsaveas(f, \'$pfname\');\nrobustness_x;\nrobustness_y;\n";

print MAT "solutionF2=optimizeCbModel(model);\nbiomass=solutionF2.f;\nbiomass\n";
#

$mfname=~s/\.m//g;
#$output=`matlab -nodesktop -nosplash -r "pathdef; $mfname; exit";`;
@output=split /\n/, $output;

$flag_biomass=0;
$flag_robust_x=0;
$flag_robust_y=0;

foreach $each (@output) {

	if($each =~/\=/){
		$flag_robust_x=0;
		$flag_robust_y=0;
		$flag_biomass=0;
	}

	if($each =~/robustness_x/){
		$flag_robust_x=1;
	}
	if($each =~/robustness_y/){
		$flag_robust_y=1;
	}
	if($each =~/biomass/){
		$flag_biomass=1;
	}
	if( $flag_robust_x == 1){
		if($each =~/[\d\.\-]/){
			$each=~s/\s//g;
			$each=~s/\n//g;
			push @robustness_x, $each;
		}	

	}
	if( $flag_robust_y == 1){
		if($each =~/[\d\.\-]/){
			$each=~s/\s//g;
			$each=~s/\n//g;
			push @robustness_y, $each;
		}	

	}
	if( $flag_biomass == 1){
		if($each =~/[\d\.\-]/){
			$each=~s/\s//g;
			$each=~s/\n//g;
			$biomass=$each;
		}	

	}
	
}
$"="\n";
print "$mfname\t$ARGV[2]\t$ARGV[3]\t$ARGV[1]\t$biomass\n";

#print OUT $output;
#print "$mfname\t$ARGV[1]\t$biomass\n";
####################################################################################################

sub get_constraints{

	my $gene_association=shift;	
	#print "gene association: $gene_association\n";
	my $total_retval=0;
	my %retval=();
	my @comparray=();
	#my ($comp, $sep, @comp);
	if($gene_association =~/\(([^\)]+)\)([^\(]+)?/){
		$comp= $1;
		$sep=$2;
		push @comparray, $comp;
		push @comparray, $sep;
		@comp=split /\s+/ , $comp;

		for ($i = 0; $i <= $#comp; $i += 2) {
			#print "$comp[$i]\t$gene_name{$comp[$i]}\t$intensity{$gene_name{$comp[$i]}}\n";
			$comp[$i]=$intensity{$gene_name{$comp[$i]}};

		}
		$old_retval=$comp[0];
		if($#comp <= 1){$retval{$comp}=$old_retval}
		else{
			for ($i = 1; $i <= $#comp-1; $i += 2) {

				$retval{$comp}=$sub_ref{$comp[$i]}->($old_retval, $comp[$i+1]) ;
				$old_retval=$retval{$comp};
			}
		}
		while($'=~/\(([^\)]+)\)([^\(]+)?/){
			$comp= $1;
			$sep=$2;
			#print "post match is: $&\n";
			push @comparray, $comp;
			push @comparray, $sep;
			@comp=split /\s+/ , $comp;

			for ($i = 0; $i <= $#comp; $i += 2) {
				#print "$comp[$i]\t$gene_name{$comp[$i]}\t$intensity{$gene_name{$comp[$i]}}\n";
				$comp[$i]=$intensity{$gene_name{$comp[$i]}};

			}
			$old_retval=$comp[0];
			if($#comp <= 1){$retval{$comp}=$old_retval}
			else{
				for ($i = 1; $i <= $#comp-1; $i += 2) {
			#print "\$\$\$\$\$\$\$\$\$\$$comp[$i]\t$sub_ref{$comp[$i]}\n";
					$retval{$comp}=$sub_ref{$comp[$i]}->($old_retval, $comp[$i+1]) ;
					$old_retval=$retval{$comp};
				}
			}
		}
	}

	$old_total=$retval{$comparray[0]};
	if($#comparray <= 1){
		#print "old_retval: ".$old_total."\n";
		return $old_total;
	}
	else{
		#map{print "$_\t$comparray[$_]\n"}(0..$#comparray);
		for ($i = 1; $i <= $#comparray-1; $i+=2) {
			$comparray[$i] =~ s/\s//g;			
			#print "#$comparray[$i]\t$sub_ref{$comparray[$i]}\n";
			$total_retval=$sub_ref{$comparray[$i]}->($old_total,$retval{$comparray[$i+1]} );

			$old_total=$total_retval;

		}
		#print "retval: $total_retval\n";
	}


	return $total_retval;

}



      
