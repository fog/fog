Shindo.tests('Fog::Compute[:openstack] | availability zone requests', ['openstack']) do

  @flavor_format = {
    'zoneName'    => String,
    'hosts'       => Fog::Nullable::Hash,
    'zoneState'   => Hash,
  }

  tests('success') do
    tests('#list_zones').data_matches_schema({'availabilityZoneInfo' => [@flavor_format]}) do
      Fog::Compute[:openstack].list_zones.body
    end

    tests('#list_zones_detailed').data_matches_schema({'availabilityZoneInfo' => [@flavor_format]}) do
      Fog::Compute[:openstack].list_zones_detailed.body
    end
  end
end
