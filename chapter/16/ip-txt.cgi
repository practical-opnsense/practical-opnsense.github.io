#!/usr/bin/perl
# [de] Sende die Verbindungsinformationen als Text an den aufrufenden Browser
# [en] Send connection information in text format to the requesting web browser

print "Content-type: text/plain\n\n";

printf "Welcome to the Internet (%s)\n",
        $ENV{'SERVER_NAME'};
print "Client IP address: " . $ENV{'REMOTE_ADDR'} . "\n";

my ($sec,$min,$hour,$day,$mon,$year,$yday,$tz) = localtime( time );
printf "Timestamp %04d/%02d/%02d %02d:%02d:%02d\n",
        $year+1900, $mon+1, $day, $hour, $min, $sec;
