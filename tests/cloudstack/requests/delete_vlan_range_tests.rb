Shindo.tests('Fog::Compute[:cloudstack] | delete vlan ip range requests', ['cloudstack']) do

  @delete_info_format = {
      'deletevlaniprangeresponse'  => {
          'count'                   => Integer,
          'delete_info'            => {
            'displaytext'           => String,
            'success'               => Fog::Boolean
          }
      }
  }

  tests('success') do
    tests('#delete_vlan_ip_range').formats(@delete_info_format) do
      Fog::Compute[:cloudstack].delete_vlan_ip_range
    end
  end

end
