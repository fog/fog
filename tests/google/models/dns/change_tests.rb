Shindo.tests('Fog::DNS[:google] | change model', ['google']) do
  # Google requires confirmation of ownership for created domains in some cases.
  # If you want to run tests in non-mocked mode, set the environment variable to a domain you own.
  unless Fog.mocking? || ENV['FOG_TEST_GOOGLE_DNS_ZONE']
    tests('Needs a verified domain, set $FOG_TEST_GOOGLE_DNS_ZONE').pending
  end

  @dns = Fog::DNS[:google]
  @zone = @dns.zones.create(
    :name => Fog::Mock.random_letters(16),
    :domain => ENV['FOG_TEST_GOOGLE_DNS_ZONE'] || generate_unique_domain,
    :description => 'Fog test domain'
  )

  tests('success') do

    tests('#pending?').succeeds do
      @dns.changes(:service => @dns, :zone => @zone).get('0').pending? == false
    end

    tests('#ready?').succeeds do
      @dns.changes(:service => @dns, :zone => @zone).get('0').ready? == true
    end

  end

  @zone.destroy
end
