Shindo.tests('Fog::Compute[:cloudstack] | list vlan ip range requests', ['cloudstack']) do

  @vlan_format = {
      'listvlaniprangeresponse'  => {
      'count'                    => Integer,
      'vlan_ip_ranges'           => {
        'id'                => String,
        'account'           => String,
        'description'       => Fog::Nullable::String,
        'domain'            => Hash,
        'domainid'          => String,
        'forvirtualnetwork' => Fog::Boolean,
        'networkid'         => String,
        'physicalnetworkid' => String,
        'poid'              => String,
        'podname'           => String,
        'project'           => String,
        'projectid'         => String,
        'zoneid'            => String,
        'gateway'           => String,
        'netmask'           => String,
        'startip'           => String,
        'endip'             => String,
        'vlan'              => Integer
      }
    }
  }

  tests('success') do
    tests('#list_vlan_ip_ranges').formats(@vlan_format) do
      Fog::Compute[:cloudstack].list_vlan_ip_ranges
    end
  end

end
