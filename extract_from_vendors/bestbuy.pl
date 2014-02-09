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
push @{ $ua->requests_redirectable }, 'POST';

# Request object
my $query = "computer";
my $url = "http://www.bestbuy.com";
# print $url . "\n";
my $req = POST 'http://www.bestbuy.com/site/searchpage.jsp', [ _dyncharset=>'ISO-8859-1',id=>'pcat17071',type=>'page',sc=>'Global',cp=>'1',nrp=>'15',list=>'n',iht=>'y',usc=>'All+Categories',ks=>'960',saas=>'saas',st=>$query ];

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

$content =~ s/\n//g;
$content =~ s/\r//g;
# print $content;

my $num = 0;
my $product_link_regex = "itemprop\=\"name.+?href\=\"([^\"]*)";
my $title_regex = "\>([^<]*)";
my $price_regex = "itemprop\=\"price\"\>([^<]*)";

while ($content =~ m/(?ms)$product_link_regex.$title_regex.+?$price_regex/gsm){
    ++$num;
    my $product_link = undef;
    # if ($1 =~ m/\.com/){
    #     $product_link = $1;
    # }else{
        $product_link = $url.$1;
    # }
    my $title = $2;
    $title =~ s/\n//g;
    $title =~ s/\r//g;
    my $price = $3;
    $price =~ s/\$//g;

    # print $product_link,"\n";
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
    ($description) = $desc_content =~ m/meta\sname\=\"description.+?\"([^\"]*)/;

    if (!defined($description)){
        $description = "No description available";
    }
    print "title: " . $title . "\n";
    print "product link: " . $product_link . "\n";
    print "product description: " . $description . "\n";
    print "price: " . $price . "\n";
    print "\n";
}

print "total number: " . $num . "\n";
    
exit 0;
