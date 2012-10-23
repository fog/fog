Shindo.tests('Fog::Compute[:gce] | zone requests', ['gce']) do

  @gce = Fog::Compute[:gce]

  @get_zone_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'creationTimestamp' => String,
      'name' => String,
      'description' => String,
      'status' => String,
      'maintenanceWindows' => []
  }

  @list_zones_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'items' => []
  }

  tests('success') do

    tests("#get_zone").formats(@get_zone_format) do
      zone_name = @gce.list_zones.body["items"][0]["name"]
      @gce.get_zone(zone_name).body
    end

    tests("#list_zones").formats(@list_zones_format) do
      @gce.list_zones.body
    end

  end

end
