require 'fog'

#
# Create the connection to the XenServer host
#
xenserver = Fog::Compute.new({
  :provider           => 'XenServer',
  :xenserver_url      => '1.2.3.4',
  :xenserver_username => 'root',
  :xenserver_password => 'secret',
})

# We have a bonded interface in XenServer, bond0 and
# we want to add the VLANs there.
# Note the VLAN ID -1, it is important since you
# will problably have many PIFs with device == bond0
# but we need the one without a proper VLAN ID
#
bondmaster_pif = xenserver.pifs.find do |pif|
  pif.vlan == "-1" and pif.device == "bond0"
end

# Another valid way of finding a PIF, without bonding
# pif = xenserver.pifs.find { |pif| pif.physical and pif.device == 'eth0' }

# We want to create these new VLANs
vlans = [
  { "name" => "VLAN 44", "vlanid" => 44},
  { "name" => "VLAN 55", "vlanid" => 55}
]

vlans.each do |vlan|
  # Do not create duplicated networks
  if xenserver.networks.find { |n| n.name == vlan['name'] }
    puts "Network #{vlan['name']} available, skipping"
    next
  end

  puts "Craeting Network #{vlan['name']}, VLAN ID #{vlan['vlanid']}"
  network = xenserver.networks.create :name => vlan['name']
  xenserver.vlans.create :tag => vlan['vlanid'],
                         :network => network,
                         :pif => bondmaster_pif
end
