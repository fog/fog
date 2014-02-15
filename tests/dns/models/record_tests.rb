for provider, config in dns_providers

  # FIXME: delay/timing breaks things :(
  next if [:dnsmadeeasy, :rage4].include?(provider)

  domain_name = uniq_id + '.com'

  Shindo.tests("Fog::DNS[:#{provider}] | record", [provider.to_s]) do

    a_record_attributes = {
      :name   => 'a.' + domain_name,
      :type   => 'A',
      :value  => '1.2.3.4'
    }.merge!(config[:record_attributes] || {})

    aaaa_record_attributes = {
      :name   => 'aaaa.' + domain_name,
      :type   => 'AAAA',
      :value  => '2001:0db8:0000:0000:0000:ff00:0042:8329'
    }.merge!(config[:record_attributes] || {})

    cname_record_attributes = {
      :name   => 'cname.' + domain_name,
      :type   => 'CNAME',
      :value  => 'real.' + domain_name
    }.merge!(config[:record_attributes] || {})

    if !Fog.mocking? || config[:mocked]
      zone_attributes = {
        :domain => domain_name
      }.merge(config[:zone_attributes] || {})

      @zone = Fog::DNS[provider].zones.create(zone_attributes)

      model_tests(@zone.records, a_record_attributes, config[:mocked])
      model_tests(@zone.records, aaaa_record_attributes, config[:mocked])
      model_tests(@zone.records, cname_record_attributes, config[:mocked])

      @zone.destroy
    end

  end

end
