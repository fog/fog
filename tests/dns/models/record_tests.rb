for provider, config in dns_providers

  params = {
    :ip => '1.2.3.4',
    :name => 'www.fogrecordtests.com',
    :type => 'A'
  }.merge!(config[:record_params] || {})

  if !Fog.mocking? || provider[:mocked]
    @zone = provider[:dns].zones.create(:domain => 'fogrecordtests.com')

    model_tests(@zone.records, params, config[:mocked])

    @zone.destroy
  end

end