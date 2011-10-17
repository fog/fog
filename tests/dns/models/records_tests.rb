for provider, config in dns_providers

  # FIXME: delay/timing breaks things :(
  next if [:dnsmadeeasy].include?(provider)

  Shindo.tests("Fog::DNS[:#{provider}] | records", [provider.to_s]) do

    record_attributes = {
      :name   => 'www.fogrecordstests.com',
      :type   => 'A',
      :value  => '1.2.3.4'
    }.merge!(config[:record_attributes] || {})

    if !Fog.mocking? || config[:mocked]
      zone_attributes = {
        :domain => 'fogrecordstests.com'
      }.merge(config[:zone_attributes] || {})

      @zone = Fog::DNS[provider].zones.create(zone_attributes)

      collection_tests(@zone.records, record_attributes, config[:mocked])

      @zone.destroy
    end

  end

end
