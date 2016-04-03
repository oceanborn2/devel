#!perl.exe

use strict;
use Win32::IPConfig;
use Getopt::Long;

sub setDNS {
  my $ipconfig = shift;
  my $adapter = shift;
  if (! $adapter->is_dhcp_enabled) {
    $adapter->set_dns(@ARGV);
    my @dns = $adapter->get_dns;
    if (@dns) {
      print "Set to @dns\n";
    } else {
      print "Cleared\n";
    }
  } else {
    warn "Adapter is configured for DHCP\n";
  }
}

sub getNetworkingInfo {
  my $ipconfig = shift;
  print "hostname=", $ipconfig->get_hostname, "\n";
  print "domain=", $ipconfig->get_domain, "\n";
  my @searchlist = $ipconfig->get_searchlist;
  print "searchlist=@searchlist (", scalar @searchlist, ")\n";
  print "nodetype=", $ipconfig->get_nodetype, "\n";
  print "IP routing enabled=", $ipconfig->is_router ? "Yes" : "No", "\n";
  print "WINS proxy enabled=", $ipconfig->is_wins_proxy ? "Yes" : "No", "\n";
  print "LMHOSTS enabled=",    $ipconfig->is_lmhosts_enabled ? "Yes" : "No", "\n";
  print "DNS enabled for netbt=",  $ipconfig->is_dns_enabled_for_netbt ? "Yes" : "No", "\n"; 
  foreach my $adapter ($ipconfig->get_adapters) {
    print "\nAdapter '", $adapter->get_name, "':\n";
    print "Description=", $adapter->get_description, "\n";
    print "DHCP enabled=",$adapter->is_dhcp_enabled ? "Yes" : "No", "\n";
    my @ipaddresses = $adapter->get_ipaddresses;
    print "IP addresses=@ipaddresses (", scalar @ipaddresses, ")\n";
    my @subnet_masks = $adapter->get_subnet_masks;
    print "subnet masks=@subnet_masks (", scalar @subnet_masks, ")\n";
    my @gateways = $adapter->get_gateways;
    print "gateways=@gateways (", scalar @gateways, ")\n";
    print "domain=", $adapter->get_domain, "\n";
    my @dns = $adapter->get_dns;
    print "dns=@dns (", scalar @dns, ")\n";
    my @wins = $adapter->get_wins;
    print "wins=@wins (", scalar @wins, ")\n";
  }
}


my ($host, $itfname);
$host = shift @ARGV || "PAR-MUNEROTPRET";

my $ipconfig = Win32::IPConfig->new($host);
my $adapter = $ipconfig->get_adapter($itfname);
if (defined($ipconfig) && defined($adapter)) {
  $adapter->set_dhcp_enabled, 0;
}





