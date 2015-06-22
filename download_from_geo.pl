#!/usr/bin/perl
use LWP::Simple;
use HTTP::Cookies;
use HTML::Parse;
use HTML::Element;
use LWP::UserAgent;
use Data::Dumper;

$accession=$ARGV[0];
my $url = "http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?view=data&acc=$accession&targ=self&view=brief&form=text";  
my $ua;
my $request;
my $response;
my $html;
        
# Create a request    
$ua = LWP::UserAgent->new;
$ua->agent("MyApp/0.1");
        
#use when proxy is available....        
$ua->proxy(['http','ftp'],"http://172.16.2.37:<PORT>");      
#(GET 'http://*************); 
$request = HTTP::Request->new('GET',$url);     #The GET() function returns an HTTP::Request object initialized with the "GET" method and the specified URL
        
$request->header('Accept' => 'text/html');
$request->proxy_authorization_basic('<USERNAME>', '<PASSWORD>');
       
# Pass request to the user agent and get a response back...
$response = $ua->request($request); 
        
my $content = getprint($url) or die 'Unable to get page';
exit 0;
