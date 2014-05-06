Shindo.tests('Fog::Compute[:cloudstack] | create vlan ip range requests', ['cloudstack']) do

  @ip_range_info_format = {
      'createvlaniprangeresponse'  => {
          'count'                   => Integer,
          'vlan_ip_ranges'                 => {
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
    tests('#create_vlan_ip_range').formats(@ip_range_info_format) do
      Fog::Compute[:cloudstack].create_vlan_ip_range
    end
  end

end
