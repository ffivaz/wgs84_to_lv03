use JSON;
use Data::Dumper;
use LWP::Simple;
use POSIX;
use strict;

my $num_args = $#ARGV + 1;
if ($num_args != 3) {
    print "\nUsage: script.pl infile outfile [dd or dms]\n";
    exit;
}

if (($ARGV[2] != "dd") || ($ARGV[2] != "dms")) {
	print "\nUsage: script.pl infile outfile [dd or dms]\n";
	exit;
}

my $filename = $ARGV[0];
open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open infile '$filename' $!";

my (@ddm0, @ddm1, @ddm2, @ddm3);
my $json;
my $ddm = 0;
my $lat;
my $lon;

while (<$fh>) {
	my @split = split("\t");
	push @ddm0, $split[0];
	push @ddm1, $split[1];
	push @ddm2, $split[2];
	push @ddm3, $split[3];
}

my $exportfile = $ARGV[1];
open(my $fh2, '>', $exportfile) or die "Could not open outfile '$exportfile' $!";
print $fh2 "ID\tCX\tCY\tALT\n";

foreach ( @ddm0 ) {
	$ddm = $ddm + 1;
	
	if ($ARGV[2] == "ddm") {
		my @dm = split(" ", $ddm1[$ddm]);
		$lon = $dm[2] / 3600 + $dm[1] / 60 + $dm[0];

		@dm = split(" ", $ddm2[$ddm]);
		$lat = $dm[2] / 3600 + $dm[1] / 60 + $dm[0];
	} else {
		$lon = $ddm1[$ddm];
		$lat = $ddm2[$ddm];
	}
	
	my $url = "http://geodesy.geo.admin.ch/reframe/wgs84tolv03?easting=$lat&northing=$lon&altitude=$ddm3[$ddm]&format=json";
	
	$json = get( $url );
	my $text = decode_json( $json );
	my $x = floor($text->{easting});
	my $y = floor($text->{northing});
	my $alt = floor($text->{altitude});
	print $fh2 "$ddm0[$ddm]\t$x\t$y\t$alt\n";
	$| = 1;
	print ".";
}

close $fh2;
