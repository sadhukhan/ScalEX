# ScalEX
# Algorithm to incorporate Transcriptomics data into whole Genome-scale Metabolic models as constraints.

# STEP 1 : Remotely access NCBI-GEO db.
gedatafilename.input = Program1.pl(GE.dat){
  GSM = download_from_geo.pl($gsm);
  GSM.txt = process_html.pl(GSM);
  GPL = download_from_geo.pl(gpl);
  gedatafilename.input = create_scalex_input.pl(GSM.txt, GPL.txt);
  };

# STEP 2 : Max-normalize the data and Pool the samples 
gedatafilename.input = autoMaxNorm.pl(GE.dat){
  gedatafilename.avg = mean.pl(gedatafilename.input);
  gedatafilename.maxnorm = max_norm.pl(gedatafilename.avg);
  };
  
if(pooling required){
  cd /datasetDirectory
  pooledsample.input = pooling.pl(*.maxnorm)
  };
else{
  gedatafilename.input = gedatafilename.maxnorm
  };
  
# STEP 3 : Create MATLAB-program files for applying constarints into the model.
                  (Can be easily modified to Python also)
pooledsample.m = ScalEX.pl(dataset){
  pooledsample.m = eflux(pooledsample.input, $alphaValue, $betaValue, gene_names.pm, recpn.xml);
  }
