use JSON;
use Data::Dumper;
use LWP::Simple;
use POSIX;
use strict;

my $num_args = $#ARGV + 1;
if ($num_args != 2) {
    print "\nUsage: lv03_to_wgs84.pl infile outfile\n";
    exit;
}

my $filename = $ARGV[0];
open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open infile '$filename' $!";

my (@ddm0, @ddm1, @ddm2, @ddm3);
my $json;
my $ddm = 0;

while (<$fh>) {
	my @split = split("\t");
	push @ddm0, $split[0];
	push @ddm1, $split[1];
	push @ddm2, $split[2];
	push @ddm3, $split[3];
}

my $exportfile = $ARGV[1];
open(my $fh2, '>', $exportfile) or die "Could not open outfile '$exportfile' $!";
print $fh2 "ID\tLAT\tLNG\tALT\n";

foreach ( @ddm0 ) {
	$ddm = $ddm + 1;
	
	my $url = "http://geodesy.geo.admin.ch/reframe/lv03towgs84?easting=$ddm1[$ddm]&northing=$ddm2[$ddm]&altitude=$ddm3[$ddm]&format=json";
	
	$json = get( $url );
	my $text = decode_json( $json );
	my $lat = $text->{easting};
	my $lng = $text->{northing};
	my $alt = floor($text->{altitude});
	print $fh2 "$ddm0[$ddm]\t$lng\t$lat\t$alt\n";
	$| = 1;
	print ".";
}

close $fh2;
