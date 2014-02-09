#!/usr/bin/perl -w
use strict;
use LWP::Simple;
my $url = "http://www.wunderground.com/cgi-bin/findweather/hdfForecast?". "query=";
my $ca = get("${url}95472"); # Sebastopol, California
my $ma = get("${url}02140"); # Cambridge, Massachusetts

my $ca_temp = current_temp($ca);
my $ma_temp = current_temp($ma);
my $diff = $ca_temp - $ma_temp;
# print $ca_temp,"\n";
# print $ma_temp,"\n";
# print $diff,"\n";
print $diff > 0 ? "California" : "Massachusetts";
print " is warmer by ", abs($diff), " degrees F.\n";

sub current_temp {
	local $_ = shift;
	my @line = $_=~ m/tempActual.*value="\d+.\d/g;
	# print $line[0];
	my @output = $line[0] =~ m/\d+.\d/g;
	return $output[0];
}

