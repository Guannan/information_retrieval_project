#!/usr/bin/env perl
use strict;
use warnings;
use HTTP::Request::Common qw(POST);
use LWP::UserAgent;
use HTTP::Cookies;
use URI;
 
# my $ua = LWP::UserAgent->new;
#  $ua->cookie_jar(HTTP::Cookies->new(file => "lwpcookies.txt",autosave => 1));
#  my $req = HTTP::Request->new(GET => 'http://www.drivehq.com/Secure/LogonOption.aspx?gotoURL=');
 
#  $req->authorization_basic($user, $pass);
 
#  my $content = $ua->request($req)->as_string;
# print "$content\n";


# my $plate = $ARGV[0] || die "Plate to search for?\n";
# $plate = uc $plate;

# my $browser = LWP::UserAgent->new;
# my $response = $browser->post('http://plates.ca.gov/search/search.php3',
# 	['plate' => $plate,'search' => 'Check Plate Availability'],);
# die "Error: ", $response->status_line unless $response->is_success;

# if($response->content =~ m/is unavailable/) {
# 	print "$plate is already taken.\n";
# } elsif($response->content =~ m/and available/) {
# 	print "$plate is AVAILABLE!\n";
# } else {
# 	print "$plate... Can't make sense of response?!\n";
# }

# exit;


my $ua = new LWP::UserAgent;
# my $req = POST 'http://www.barnesandnoble.com/s/', [ store=>'allproducts', keyword=>'food' ];
my $req = POST 'http://www.kmart.com/shc/s/search_10151_10104', [ keyword=>'food'];
print $ua->request($req)->as_string;


# my $url = URI->new( 'http://www.barnesandnoble.com/s/' );
# my $browser = LWP::UserAgent->new;

# $url->query_form(
# 	'store' => 'allproducts',
# 	'keyword' => 'murder',
# 	);

# my $response = $browser->get($url);
# print $response->as_string;
