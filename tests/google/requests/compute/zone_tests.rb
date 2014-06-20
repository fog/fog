Shindo.tests('Fog::Compute[:google] | zone requests', ['google']) do

  @google = Fog::Compute[:google]

  @get_zone_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'creationTimestamp' => String,
      'name' => String,
      'description' => String,
      'status' => String,
      'region' => String,
      'maintenanceWindows' => Fog::Nullable::Array
  }

  @list_zones_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'items' => [@get_zone_format]
  }

  tests('success') do

    tests("#get_zone").formats(@get_zone_format) do
      zone_name = @google.list_zones.body["items"][0]["name"]
      @google.get_zone(zone_name).body
    end

    tests("#list_zones").formats(@list_zones_format) do
      @google.list_zones.body
    end

  end

end
