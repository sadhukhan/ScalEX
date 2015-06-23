#!/usr/bin/perl

# GIT IS WORKING! FUCK TOU WOURLD!
  use strict;
  use warnings;

my $dirname='########';

my $names = '###########';

my @name = split('\n', $names);     # Delimiter

`mkdir $dirname`;
foreach my $i(@name){
`cp $i $dirname`;}

print "Done\n";
