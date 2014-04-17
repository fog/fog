Shindo.tests('Fog::Compute[:google] | region requests', ['google']) do
  @google = Fog::Compute[:google]

  @get_region_format = {
      'kind' => String,
      'selfLink' => String,
      'id' => String,
      'creationTimestamp' => String,
      'name' => String,
      'description' => String,
      'status' => String,
      'zones' => Array,
      'quotas' => [{ 'metric' => String, 'limit' => Float, 'usage' => Float }],
  }

  @list_regions_format = {
      'kind' => String,
      'selfLink' => String,
      'id' => String,
      'items' => [@get_region_format]
  }

  tests('success') do
    tests("#get_region").formats(@get_region_format) do
      region = @google.list_regions.body['items'].first['name']
      @google.get_region(region).body
    end

    tests("#list_regions").formats(@list_regions_format) do
      @google.list_regions.body
    end
  end

  tests('failure') do
    tests("#get_region").raises(Fog::Errors::NotFound) do
      @google.get_region('unicorn').body
    end
  end
end
