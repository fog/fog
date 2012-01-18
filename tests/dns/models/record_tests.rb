for provider, config in dns_providers

  # FIXME: delay/timing breaks things :(
  next if [:dnsmadeeasy].include?(provider)

  domain_name = uniq_id + '.com'

  Shindo.tests("Fog::DNS[:#{provider}] | record", [provider.to_s]) do

    record_attributes = {
      :name   => 'www.' + domain_name,
      :type   => 'A',
      :value  => '1.2.3.4'
    }.merge!(config[:record_attributes] || {})

    if !Fog.mocking? || config[:mocked]
      zone_attributes = {
        :domain => domain_name
      }.merge(config[:zone_attributes] || {})

      @zone = Fog::DNS[provider].zones.create(zone_attributes)

      model_tests(@zone.records, record_attributes, config[:mocked])

      @zone.destroy
    end

  end

end
