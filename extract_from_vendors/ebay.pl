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
my $query = "tanktops";
my $book_category = "267";  #books, need to play around with other cats
my $clothing_category = "11450";
my $computer_category = "58058";
my $office_category = "12576";
my $url = "http://www.ebay.com";
# print $url . "\n";
my $req = POST 'http://www.ebay.com/sch/i.html', [ _nkw=>$query, _sacat=>$clothing_category];

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

#print $content;

#TODO might want to add bid time left
my $num = 0;
my $book_product_link_regex = "class\=\"ittl.+?href\=\"([^\"]*)";
my $computer_product_link_regex = "class\=\"ittl.+?href\=\"([^\"]*)";
my $office_product_link_regex = "class\=\"ittl.+?href\=\"([^\"]*)";
my $clothing_product_link_regex = "class\=\"ititle.+?href\=\"([^\"]*)";
my $title_regex = "itemprop\=\"name\"\>([^<]*)";
my $price_regex = "itemprop\=\"price.+?\$([^<]*)";
my $clothing_price_regex = "itemprop\=\"price([^<]*)";

my $computer_regex = qr/(?ms)class="ittl.+?href="([^"]*).+?itemprop="name">([^<]*).+?itemprop="price.+?$([^<]*)/;
my $clothing_regex = qr/(?ms)class="ititle.+?href="([^"]*).+?itemprop="name">([^<]*).+?itemprop="price([^<]*)/;
my $office_regex = qr/(?ms)class="ittl.+?href="([^"]*).+?itemprop="name">([^<]*).+?itemprop="price.+?$([^<]*)/;
my $book_regex = qr/(?ms)class="ittl.+?href="([^"]*).+?itemprop="name">([^<]*).+?itemprop="price.+?$([^<]*)/;

while ($content =~ m/$clothing_regex/gm){
    ++$num;
    my $product_link = undef;
    # if ($1 =~ m/\.com/){
        $product_link = $1;
    # }else{
        # $product_link = $url.$1;
    # }
    my $title = $2;
    my $price = $3; 
    $price =~ s/.+?\$//gm;
    $price =~ s/\s//gm;

    # print $product_link,"\n";
    my $product_page = GET $product_link;
    my $page_content = $ua->request($product_page);
    my $desc_content = undef;
    if ($page_content->is_success) {
        $desc_content = $page_content->content;
    } else {
        print $page_content->status_line . "\n";
    }
    # # print $desc_content;

    my $description = undef;
    ($description) = $desc_content =~ m/meta\sname\=\"description.+?content\=\"([^\"]*)/sm;

    if (!defined($description)){
        $description = "No description available";
    }
    print "title: " . $title . "\n";
    # print "author: " . $author . "\n";
    print "product link: " . $product_link . "\n";
    print "product description: " . $description . "\n";
    print "price: " . $price . "\n";
    print "\n";
}

print "total number: " . $num . "\n";
    
exit 0;
