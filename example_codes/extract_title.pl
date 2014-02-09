#!/usr/bin/perl -w
use strict;
use LWP::Simple;

my $query = "murder";
my $category = "allproducts";
my $url = "http://www.barnesandnoble.com/s/".$query."?store=".$category."&keyword=".$query;
my $html = get($url);

# print $html,"\n";
print extract_titles($html);

sub extract_titles {
	local $_ = shift;
	my @line = $_=~ m/data-bntrack=\"Title.*class="title"\>.*\</g;
	print $line[0];
	my @output = ();
	foreach (@line){
		# push @output,$1;
	}
	foreach (@output){
		print $_,"\n";
	}
	# my @output = $line[0] =~ m/\>[A-Za-z\s]*\</g;
	# $output[0] =~ s/\<//g;
	# $output[0] =~ s/\>//g;
	# return $output[0];
}

