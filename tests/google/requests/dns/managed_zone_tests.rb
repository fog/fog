Shindo.tests('Fog::DNS[:google] | managed_zone requests', ['google']) do

  @google = Fog::DNS[:google]

  @create_managed_zone_schema = {
      'kind' => String,
      'id' => String,
      'creationTime' => String,
      'name' => String,
      'dnsName' => String,
      'description' => String,
      'nameServers' => [String],
  }

  @list_managed_zones_schema = {
      'kind' => String,
      'managedZones' => [@create_managed_zone_schema],
  }

  tests('success') do

    zone_name = 'new-zone-test'
    # TODO: this will fail in non-mocked mode, since Google requires
    # confirmation of ownership for created domains in some cases.
    zone_dns_name = 'fog-test.your-own-domain.com.'
    # You can comment out this line if you set the above to a verified domain
    # of yours.
    tests('Needs a verified domain').pending unless Fog.mocking?

    tests("#create_managed_zone").data_matches_schema(
        @create_managed_zone_schema, {:allow_extra_keys => false}) do
      @google.create_managed_zone(zone_name, zone_dns_name).body
    end

    tests("#list_managed_zones") do
      response = @google.list_managed_zones().body
      tests('schema').data_matches_schema(@list_managed_zones_schema, {:allow_extra_keys => false}) { response }
      tests('test zone present').returns(true) { response['managedZones'].one? { |zone| zone['name'] == zone_name } }
    end

    tests("#delete_managed_zone").returns(nil) do
     @google.delete_managed_zone(zone_name).body
    end
  end

  tests('failure') do
    tests("#delete_managed_zone").raises(Fog::Errors::NotFound) do
     @google.delete_managed_zone('zone-which-does-not-exist').body
    end
  end

end
