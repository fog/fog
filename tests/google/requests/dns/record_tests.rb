Shindo.tests('Fog::DNS[:google] | record requests', ['google']) do
  # Google requires confirmation of ownership for created domains in some cases.
  # If you want to run tests in non-mocked mode, set the environment variable to a domain you own.
  unless Fog.mocking? || ENV['FOG_TEST_GOOGLE_DNS_ZONE']
    tests('Needs a verified domain, set $FOG_TEST_GOOGLE_DNS_ZONE').pending
  end

  @dns = Fog::DNS[:google]

  @get_resource_record_sets_format = {
    'kind' => String,
    'name' => String,
    'type' => String,
    'ttl' => Integer,
    'rrdatas' => Array,
  }

  @list_resource_record_sets_format = {
    'kind' => String,
    'rrsets' => [@get_resource_record_sets_format],
  }

  tests('success') do
    @zone = @dns.zones.create(
      :name => Fog::Mock.random_letters(16),
      :domain => ENV['FOG_TEST_GOOGLE_DNS_ZONE'] || generate_unique_domain,
      :description => 'Fog test domain'
    )

    tests('#list_resource_record_sets').formats(@list_resource_record_sets_format) do
      @dns.list_resource_record_sets(@zone.identity).body
    end

    tests('#list_resource_record_sets (with name and type)').formats(@list_resource_record_sets_format) do
      @dns.list_resource_record_sets(@zone.identity, { :name => @zone.domain, :type => 'NS' }).body
    end

    @zone.destroy
  end

  tests('failure') do

    tests('#list_resource_record_sets').raises(Fog::Errors::NotFound) do
      @dns.list_resource_record_sets(generate_unique_domain).body
    end

  end

end
