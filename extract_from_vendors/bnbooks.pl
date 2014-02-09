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
my $query = "sherlock";
my $category = "book";
my $url = "http://www.barnesandnoble.com/s/".$query."?store=".$category."&keyword=".$query;
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
my $title_regex = "data-bntrack\=\"Title.+?class\=\"title\"\>[\<span title\=]*([^><]*)";
my $author_regex = "data-bntrack\=\"Contributor.+?class\=\"contributor\"\>([^><]*)";
my $product_link_regex = "class\=\"price-format.+?href\=\"([^<\"]*)";
# my $price_regex = "data-bntrack\=\"NOOK.+?class\=\"price\"\>([^><]*)";

#some titles are in quotation, and some don't . this is due to span tag for the ones that do.
while ($content =~ m/(?ms)$title_regex.+?$author_regex.+?$product_link_regex/g){
    ++$num;     
    my $title = $1;
    my $author = $2;
    # my $rating = $3;
    # my $bookseller = $3;
    # my $quantity = $4;
    my $product_link = $3;
    # my $price = $4;

    my $product_page = GET $product_link;
    my $page_content = $ua->request($product_page);
    my $desc_content = undef;
    if ($page_content->is_success) {
        $desc_content = $page_content->content;
    } else {
        print $page_content->status_line . "\n";
    }
    # print $desc_content;

    my $meta_description = undef;
    ($meta_description) = $desc_content =~ m/meta\sname\=\"description.+?content\=\"([^\"]*)/sm;

    my $description = undef;
    #my $description_regex = "class\=\"content box.+?Overview.+?class\=\"simple-html\"\>.+?[\<p\>]*(.+?)</section>";
    ($description) = $desc_content =~ m/class\=\"content box.+?Overview.+?class\=\"simple-html\"\>.+?[\<p\>]*(.+?)<\/section>/;

    $desc_content =~ s/\n//g;
    $desc_content =~ s/\r//g;
    $desc_content =~ s/\s//g;

    my $pb_bn_price = undef;
    my $pb_mk_price = undef;
    my $hc_bn_price = undef;
    my $hc_mk_price = undef;
    ($pb_bn_price) = $desc_content =~ m/data-bntrack\=\"Paperback.+?class\=\"bn-price.+?data-bntrack=\"ParentBNPrice.+?\$([^<]*)/;
    ($pb_mk_price) = $desc_content =~ m/data-bntrack\=\"Paperback.+?class\=\"mp-price.+?data-bntrack=\"ParentMPPrice.+?\$([^<]*)/; 
    ($hc_bn_price) = $desc_content =~ m/data-bntrack\=\"Hardcover.+?class\=\"bn-price.+?data-bntrack=\"ParentBNPrice.+?\$([^<]*)/;
    ($hc_mk_price) = $desc_content =~ m/data-bntrack\=\"Hardcover.+?class\=\"mp-price.+?data-bntrack=\"ParentMPPrice.+?\$([^<]*)/; 
    
    print "title: " . $title . "\n";
    print "author: " . $author . "\n";
    # print "product link: " . $product_link . "\n";
    # print "price: " . $price . "\n";
    my $lowest_pb = undef;
    if (defined($pb_bn_price) and defined($pb_mk_price)){
        $lowest_pb = ($pb_bn_price > $pb_mk_price ? $pb_mk_price : $pb_bn_price);
    }elsif (defined($pb_bn_price)){
        $lowest_pb = $pb_bn_price;
    }elsif (defined($pb_mk_price)){
        $lowest_pb = $pb_mk_price;
    }else{
        $lowest_pb = "";
    }

    my $lowest_hc = undef;
    if (defined($hc_bn_price) and defined($hc_mk_price)){
        $lowest_hc = ($hc_bn_price > $hc_mk_price ? $hc_mk_price : $hc_bn_price);
    }elsif (defined($hc_bn_price)){
        $lowest_hc = $hc_bn_price;
    }elsif (defined($hc_mk_price)){
        $lowest_hc = $hc_mk_price;
    }else{
        $lowest_hc = "";
    }

    if (defined($lowest_pb)){
        print "Lowest paperback price: " . $lowest_pb . "\n";
    }
    if (defined($lowest_hc)){
        print "Lowest hardcover price: " . $lowest_hc . "\n";
    }

    # print "Product link " . $product_link ."\n";
    print "product meta description: " . $meta_description . "\n";
    # print "product description: " . $description . "\n";
    print "\n";
}

print "total number: " . $num . "\n";
    
exit 0;
