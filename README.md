# wgs84_to_lv03
A small PERL script to convert WGS84 (DD or DMS) coordinates to LV03 (swiss) using Swisstopo REST API

## Usage

<code> wgs84_to_lv03.pl infile outfile [dd or ddm] </code>

All three arguments are compulsory

## Infile structure
The first line is omitted.

**ID**  Unique ID (will be transfered to outfile)

**LAT** ellipsoidal latitude (in decimal degrees, eg. 47.413047 or in degrees, minutes, seconds, eg. 47 24 46.97 with spaces between)

**LON** ellipsoidal longitude (in decimal degrees, eg. 47.413047 or in degrees, minutes, seconds, eg. 47 24 46.97 with spaces between)

**ALT** Altitude (in meters)

## Outfile structure
The last line is junk (zeroes basically).

**ID** Unique ID (from infile)

**CX** X-coordinates in meters

**CY** Y-coordinates in meters

**ALT** Altitude (in meters)

## References
See the swisstopo website for details on the conversion method

http://www.swisstopo.admin.ch/internet/swisstopo/en/home/products/software/products/m2m/wgs84tolv03.html
