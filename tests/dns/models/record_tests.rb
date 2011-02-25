for provider, config in dns_providers

  Shindo.tests("#{provider}::DNS | record", [provider.to_s.downcase]) do

    record_attributes = {
      :ip => '1.2.3.4',
      :name => 'www.fogrecordtests.com',
      :type => 'A'
    }.merge!(config[:record_attributes] || {})

    if !Fog.mocking? || config[:mocked]
      zone_attributes = {
        :domain => 'fogrecordtests.com'
      }.merge(config[:zone_attributes] || {})

      @zone = provider[:dns].zones.create(zone_attributes)
      model_tests(@zone.records, record_attributes, config[:mocked])

      @zone.destroy
    end

  end

end