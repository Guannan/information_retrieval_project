#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
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
my $query = "paperclip";
my $url = "http://www.staples.com/".$query."/directory_".$query."?";
print $url . "\n";
my $req = GET $url;

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

my $num = 0;
my $product_link_regex = "div class\=\"name.+?href\=\"([^<\"]*)";
my $title_regex = "title\=\".+?\>([^><]*)";
my $price_regex = "class\=\"pis\"\>\<b\>\<i\>([^<]*)";  #TODO for some reason, dollar sign is not recognized

#some titles are in quotation, and some don't . this is due to span tag for the ones that do.
while ($content =~ m/(?ms)$product_link_regex.+?$title_regex.+?$price_regex/gsm){
    ++$num;
    my $product_link = "http://www.staples.com" . $1;
    my $title = $2;
    my $price = $3;
    $price =~ s/\$//g;

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
    ($description) = $desc_content =~ m/(?ms)Product\sDetails(.+?)cmp/sm;    

    my $alt_description = undef;
    ($alt_description) = $desc_content =~ m/(?ms)Product\sDetails(.+?)cmp/gsm;
    $alt_description =~ s/\n//g;
    $alt_description =~ s/\r//g;

    # $desc_content =~ s/\n//g;
    # $desc_content =~ s/\r//g;
    # $desc_content =~ s/\s//g;    
    print "title: " . $title . "\n";
    # print "product link: " . $product_link . "\n";
    print "product description: " . $description . "\n";
    print "price: " . $price . "\n";
    print "\n";
}

print "total number: " . $num . "\n";
    
exit 0;
