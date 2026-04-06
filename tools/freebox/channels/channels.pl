use warnings FATAL => 'all';
use strict;

my $CMD="jq '.[] |
{
    logo: .image.src,
    name: .details.title,
    desc: .details.description,
    price: .details.price,
    cat: .details.categories
}' channels_small.json > channels_small";

qx($CMD);

# while (defined(my $line=<>)) {
#     chomp($line)   ;
#     my $channel = $line;
#
#     my $title = <>;
#     chomp($title);
#
#     my $description= <>;
#     chomp($description);
#
#     print "$channel;$title;$description\n";
# }