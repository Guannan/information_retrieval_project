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
my $query = "coffee makers";
my $url = "http://www.sears.com";
# print $url . "\n";
my $req = POST 'http://www.sears.com/shc/s/search_10153_12605', [ keyword=>$query,autoRedirect=>'false',catPrediction=>'false',keywordSearch=>'false'];

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

while ($content =~ m/(?ms)$product_link_regex.+?$title_regex.+?$price_regex/g){
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

    my $alt_description = undef;
    ($alt_description) = $desc_content =~ m/property\=\"gr:description.+?content\=\"([^\"]*)/sm;

    if (!defined($description)){
        $description = "No description available";
    }
    print "title: " . $title . "\n";
    # print "product link: " . $product_link . "\n";
    print "product description: " . $description . "\n";
    print "alternate product description: " . $alt_description . "\n";
    print "price: " . $price . "\n";
    print "\n";
}

print "total number: " . $num . "\n";
    
exit 0;
