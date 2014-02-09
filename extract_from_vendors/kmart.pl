#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use HTTP::Request::Common qw(GET);
use HTTP::Cookies;

my $ua = LWP::UserAgent->new;

# Define user agent type
$ua->agent('Mozilla/8.0');

# Cookies
$ua->cookie_jar(
    HTTP::Cookies->new(
        file => 'mycookies.txt',
        autosave => 1
    )
);


# Request object
# my $query = "playstation 3";
my $query = "phones";
my $url = "http://www.kmart.com";
my $clothing_category = "Clothing";
my $electronics_category = "TVs\+\%26\+Electronics";
# print $url . "\n";
# autoRedirect=>'false',catPrediction=>'false',
my $req = POST 'http://www.kmart.com/shc/s/search_10151_10104', [ keyword=>$query, autoRedirect=>'true', catPrediction=>'true', keywordSearch=>'false',vName=>$electronics_category];

# Make the request
my $res = $ua->request($req);
my $content = undef;
# Check the response
if ($res->is_success) {
    $content = $res->content;
    #print $content;
} else {
    print $res->status_line . "\n";
}

# print $content;

my $num = 0;
my $product_link_regex = "itemprop\=\"name.+?href\=\"([^\"]*)";
my $title_regex = "title\=\"([^\"]*)";
my $price_regex = "itemprop\=\"price([^<]*)";
# my $description_regex = "meta\sname\=\"description.+?content\=\"([^\"]*)";
my $clothing_regex = qr/(?ms)itemprop\=\"name.+?href\=\"([^\"]*).+?title\=\"([^\"]*).+?itemprop\=\"price([^<]*)/;

while ($content =~ m/(?ms)$clothing_regex/gm){
    ++$num;
    my $product_link = undef;
    $product_link = $url.$1;
    my $title = $2;
    my $price = $3;
    $price =~ s/^.+?\$//g;
    $price =~ s/\s//g;

    my $product_page = GET $product_link;
    my $page_content = $ua->request($product_page);
    my $desc_content = undef;
    if ($page_content->is_success) {
        $desc_content = $page_content->content;
    } else {
        print $page_content->status_line . "\n";
    }
    # print $desc_content;
    my $description = undef;
    ($description) = $desc_content =~ m/meta\sname\=\"description.+?content\=\"([^\"]*)/sm;

    if (!defined($description)){
        $description = "No description available";
    }
    print "title: " . $title . "\n";
    # print "product link: " . $product_link . "\n";
    print "product description: " . $description . "\n";
    print "price: " . $price . "\n";
    print "\n";
}

print "total number: " . $num . "\n";
    
exit 0;
