Shindo.tests('Fog::Compute[:google] | operation requests', ['google']) do

  @google = Fog::Compute[:google]

  @list_global_operations_format = {
    'kind' => String,
    'id' => String,
    'items' => [{
      'kind' => String,
      'id' => String,
      'name' => String,
      'operationType' => String,
      'targetLink' => String,
      'targetId' => String,
      'status' => String,
      'user' => String,
      'progress' => Integer,
      'insertTime' => String,
      'startTime' => String,
      'endTime' => String,
      'selfLink' => String,
    }],
    'selfLink' => String,
  }

  @list_zone_operations_format = {
    'kind' => String,
    'id' => String,
    'selfLink' => String,
    #'items' => []
  }

  tests('success') do

    tests("#list_global_operations").formats(@list_global_operations_format) do
      @google.list_global_operations.body
    end

    tests("#list_zone_operations").formats(@list_zone_operations_format) do
      zone_name = @google.list_zones.body["items"][0]["name"]
      @google.list_zone_operations(zone_name).body
    end

  end

end
