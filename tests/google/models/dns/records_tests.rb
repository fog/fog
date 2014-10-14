Shindo.tests('Fog::DNS[:google] | records model', ['google']) do
  # Google requires confirmation of ownership for created domains in some cases.
  # If you want to run tests in non-mocked mode, set the environment variable to a domain you own.
  unless Fog.mocking? || ENV['FOG_TEST_GOOGLE_DNS_ZONE']
    tests('Needs a verified domain, set $FOG_TEST_GOOGLE_DNS_ZONE').pending
  end

  @dns = Fog::DNS[:google]

  tests('success') do
    @zone = @dns.zones.create(
      :name => Fog::Mock.random_letters(16),
      :domain => ENV['FOG_TEST_GOOGLE_DNS_ZONE'] || generate_unique_domain,
      :description => 'Fog test domain'
    )

    tests('#all').succeeds do
      @dns.records(:service => @dns, :zone => @zone).all
    end

    @zone.destroy
  end

end
