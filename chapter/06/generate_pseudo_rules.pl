#!/usr/bin/perl
# [de] Zweck: viele Firewallregeln fuer OPNsense erzeugen
# [en] purpose: generate many rules for OPNsense

my $number_of_rules = shift || 10;

foreach my $c ( 1 .. $number_of_rules ) {
	my $port = int(rand( 65535 ));
	my $time = time();

	print <<EOF;
    <rule>
      <type>pass</type>
      <interface>opt1</interface>
      <ipprotocol>inet46</ipprotocol>
      <statetype>keep state</statetype>
      <descr>dummy rule #$c</descr>
      <protocol>tcp/udp</protocol>
      <source>
        <network>opt1</network>
      </source>
      <destination>
        <network>opt2</network>
        <port>$port</port>
      </destination>
      <updated>
        <username>root\@10.5.1.13</username>
        <time>$time</time>
        <description>dummy rule by $0</description>
      </updated>
      <created>
        <username>root\@10.5.1.13</username>
        <time>$time</time>
        <description>dummy rule by $0</description>
      </created>
    </rule>
EOF
}

exit( 0 );
