for provider, config in dns_providers

  Shindo.tests("#{provider}::DNS | records", [provider.to_s.downcase]) do

    attributes = {
      :ip => '1.2.3.4',
      :name => 'www.fogrecordstests.com',
      :type => 'A'
    }.merge!(config[:records_attributes] || {})

    if !Fog.mocking? || configa[:mocked]
      @zone = provider[:dns].zones.create(:domain => 'fogrecordstests.com')

      collection_tests(@zone.records, attributes, config[:mocked])

      @zone.destroy
    end

  end

end