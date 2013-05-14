for provider, config in dns_providers

  # FIXME: delay/timing breaks things :(
  next if [:dnsmadeeasy].include?(provider)

  domain_name = uniq_id + '.com'

  Shindo.tests("Fog::DNS[:#{provider}] | zone", [provider.to_s]) do

    zone_attributes = {
      :domain => domain_name
    }.merge!(config[:zone_attributes] || {})

    model_tests(Fog::DNS[provider].zones, zone_attributes, config[:mocked])

  end

end
