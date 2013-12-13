Shindo.tests('Fog::Compute[:google] | operation requests', ['google']) do
  pending if Fog.mocking?

  @google = Fog::Compute[:google]

  tests('success') do

    # We are not testing the format here because operation formats are pretty
    # extensive based on what has happened to you account, ever.
    # https://developers.google.com/compute/docs/reference/latest/globalOperations#resource
    tests("#list_global_operations").succeeds do
      @google.list_global_operations
    end

    tests("#list_zone_operations").succeeds do
      zone_name = @google.list_zones.body["items"][0]["name"]
      @google.list_zone_operations(zone_name)
    end
  end
end
