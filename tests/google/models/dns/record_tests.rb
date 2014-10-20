Shindo.tests('Fog::DNS[:google] | record model', ['google']) do
  # Google requires confirmation of ownership for created domains in some cases.
  # If you want to run tests in non-mocked mode, set the environment variable to a domain you own.
  unless Fog.mocking? || ENV['FOG_TEST_GOOGLE_DNS_ZONE']
    tests('Needs a verified domain, set $FOG_TEST_GOOGLE_DNS_ZONE').pending
  end

  @dns = Fog::DNS[:google]
  params = {
    :name => "#{Fog::Mock.random_letters(16)}.#{ENV['FOG_TEST_GOOGLE_DNS_ZONE'] || generate_unique_domain}",
    :type => 'A',
    :ttl => 3600,
    :rrdatas => ['192.168.1.1'],
  }

  tests('success') do
    @zone = @dns.zones.create(
      :name => Fog::Mock.random_letters(8),
      :domain => ENV['FOG_TEST_GOOGLE_DNS_ZONE'] || generate_unique_domain,
      :description => 'Fog test domain'
    )

    tests('#save').succeeds do
      @record = @zone.records.create(params)
    end

    tests('#modify').succeeds do
      @record.modify({ :ttl => 2600 })
    end

    tests('#reload').succeeds do
      @record.reload
    end

    tests('#destroy').succeeds do
      @record.destroy
    end

    @zone.destroy
  end

end
