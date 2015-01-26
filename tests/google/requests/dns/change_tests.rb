Shindo.tests('Fog::DNS[:google] | change requests', ['google']) do
  # Google requires confirmation of ownership for created domains in some cases.
  # If you want to run tests in non-mocked mode, set the environment variable to a domain you own.
  unless Fog.mocking? || ENV['FOG_TEST_GOOGLE_DNS_ZONE']
    tests('Needs a verified domain, set $FOG_TEST_GOOGLE_DNS_ZONE').pending
  end

  @dns = Fog::DNS[:google]

  @get_change_format = {
    'kind' => String,
    'id' => String,
    'startTime' => String,
    'status' => String,
    'additions' => Fog::Nullable::Array,
    'deletions' => Fog::Nullable::Array,
  }

  @list_changes_format = {
    'kind' => String,
    'changes' => [@get_change_format],
  }

  @zone = @dns.zones.create(
    :name => Fog::Mock.random_letters(16),
    :domain => ENV['FOG_TEST_GOOGLE_DNS_ZONE'] || generate_unique_domain,
    :description => 'Fog test domain'
  )

  rrset_resource = {
    :name => "#{Fog::Mock.random_letters(16)}.#{ENV['FOG_TEST_GOOGLE_DNS_ZONE'] || generate_unique_domain}",
    :type => 'A',
    :ttl => 3600,
    :rrdatas => ['192.168.1.1'],
  }

  tests('success') do

    tests('#create_change.additions').formats(@get_change_format) do
      @dns.create_change(@zone.identity, [rrset_resource], []).body
    end

    tests('#create_change.additions.deletions').formats(@get_change_format) do
      @dns.create_change(@zone.identity, [rrset_resource], [rrset_resource]).body
    end

    tests('#create_change.deletions').formats(@get_change_format) do
      @dns.create_change(@zone.identity, [], [rrset_resource]).body
    end

    tests('#list_changes').formats(@list_changes_format) do
      @dns.list_changes(@zone.identity).body
    end

    tests('#get_change').formats(@get_change_format) do
      @dns.get_change(@zone.identity, '0').body
    end

  end

  tests('failure') do

    tests('#list_changes').raises(Fog::Errors::NotFound) do
      @dns.list_changes(generate_unique_domain).body
    end

    tests('#get_change').raises(Fog::Errors::NotFound) do
      @dns.get_change(generate_unique_domain, Fog::Mock.random_letters_and_numbers(16)).body
    end

    tests('#get_change').raises(Fog::Errors::NotFound) do
      @dns.get_change(@zone.identity, Fog::Mock.random_letters_and_numbers(16)).body
    end

    tests('#create_change').raises(Fog::Errors::NotFound) do
      @dns.create_change(generate_unique_domain, [], [rrset_resource]).body
    end

    tests('#create_change').raises(Fog::Errors::NotFound) do
      @dns.create_change(@zone.identity, [], [rrset_resource]).body
    end

  end

  @zone.destroy
end
