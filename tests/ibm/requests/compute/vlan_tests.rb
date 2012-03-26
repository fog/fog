Shindo.tests('Fog::Compute[:ibm] | location requests', ['ibm']) do

  @vlan_format  = {
    'id'       => String,
    'name'     => String,
    'location' => String,
  }

  @vlans_format = {
    'vlan' => [ @vlan_format ]
  }

  tests('success') do

    tests("#list_vlans").formats(@vlans_format) do
      Fog::Compute[:ibm].list_vlans.body
    end

  end

end
