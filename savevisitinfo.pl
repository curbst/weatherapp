#!/usr/bin/perl

use DBI;
use strict;

sub perllog {
    my $filename = './perl.log';

   open(FH, '>>', $filename) or die $!;
   my $item = "";
   foreach $item (@_) {
     print FH $item;
   }

    close(FH);
}

#get argv
my $vid=$ARGV[0];
my $remote_ip=$ARGV[1];
my $lat=$ARGV[2];
my $lon=$ARGV[3];
my $country=$ARGV[4];
my $countryCode=$ARGV[5];
my $region=$ARGV[6];
my $regionName=$ARGV[7];
my $city=$ARGV[8];
my $zip=$ARGV[9];
my $timezone=$ARGV[10];
my $database=$ARGV[11]; #"./data/weather.db";
my $tablename=$ARGV[12];



#db
my $driver   = "SQLite"; 
my $dsn = "DBI:$driver:dbname=$database";
my $userid = "";
my $password = "";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) 
   or die $DBI::errstr;

perllog("Opened database successfully\n");



my $stmt = qq(INSERT INTO $tablename (vid,remote_ip,visittime,lat,lon,country,countryCode,region,regionName,city,zip,timezone)
               VALUES ('$vid', '$remote_ip', datetime('now'), '$lat','$lon','$country','$countryCode','$region','$regionName','$city','$zip','$timezone' ));
perllog($stmt);
my $rv = $dbh->do($stmt) or die $DBI::errstr;

perllog("\nRecords created successfully\n");
$dbh->disconnect();