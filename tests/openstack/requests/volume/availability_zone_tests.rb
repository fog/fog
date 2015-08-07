Shindo.tests('Fog::Volume[:openstack] | availability zone requests', ['openstack']) do

  @flavor_format = {
    'zoneName'  => String,
    'zoneState' => Hash,
  }

  tests('success') do
    tests('#list_zones').data_matches_schema({'availabilityZoneInfo' => [@flavor_format]}) do
      Fog::Volume[:openstack].list_zones.body
    end
  end
end
