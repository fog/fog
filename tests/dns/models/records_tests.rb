for provider, config in dns_providers

  params = {
    :ip => '1.2.3.4',
    :name => 'www.fogrecordstests.com',
    :type => 'A'
  }.merge!(config[:records_params] || {})

  if !Fog.mocking? || provider[:mocked]
    @zone = provider[:dns].zones.create(:domain => 'fogrecordstests.com')

    collection_tests(@zone.records, params, config[:mocked])

    @zone.destroy
  end

end