Shindo.tests('Fog::DNS[:google] | managed_zone requests', ['google']) do

  @google = Fog::DNS[:google]

  @managed_zone_schema = {
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
      'managedZones' => [@managed_zone_schema],
  }

  tests('success') do

    zone_name = 'new-zone-test'
    DEFAULT_ZONE_DNS_NAME = 'fog-test.your-own-domain.com.'
    # Google requires confirmation of ownership for created domains in some
    # cases.  If you want to run tests in non-mocked mode, set the environment
    # variable to a domain you own.
    zone_dns_name = ENV['FOG_TEST_GOOGLE_DNS_ZONE'] || DEFAULT_ZONE_DNS_NAME
    unless Fog.mocking? or zone_dns_name != DEFAULT_ZONE_DNS_NAME
      tests('Needs a verified domain, set $FOG_TEST_GOOGLE_DNS_ZONE').pending
    end

    tests("$FOG_TEST_GOOGLE_DNS_ZONE ends with dot").pending unless zone_dns_name.end_with?('.')

    tests("#create_managed_zone").data_matches_schema(
        @managed_zone_schema, {:allow_extra_keys => false}) do
      @google.create_managed_zone(zone_name, zone_dns_name, 'Fog test domain').body
    end

    tests("#get_managed_zone") do
      response = @google.get_managed_zone(zone_name).body
      tests('schema').data_matches_schema(@managed_zone_schema, {:allow_extra_keys => false}) { response }
      tests('test zone present').returns(zone_name) { response['name'] }
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

    tests("#get_managed_zone").raises(Fog::Errors::NotFound) do
      @google.get_managed_zone('zone-which-does-not-exist').body
    end
  end

end
