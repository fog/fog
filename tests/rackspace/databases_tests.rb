Shindo.tests('Fog::Rackspace::Databases', ['rackspace']) do |variable|

  pending if Fog.mocking?

  def assert_method(url, method)
    @service.instance_variable_set "@rackspace_auth_url", url
    returns(method) { @service.send :authentication_method }
  end

  tests('#authentication_method') do
    @service = Fog::Rackspace::Databases.new

    assert_method nil, :authenticate_v2

    assert_method 'https://identity.api.rackspacecloud.com', :authenticate_v1
    assert_method 'https://identity.api.rackspacecloud.com/v1', :authenticate_v1
    assert_method 'https://identity.api.rackspacecloud.com/v1.1', :authenticate_v1
    assert_method 'https://identity.api.rackspacecloud.com/v2.0', :authenticate_v2

    assert_method 'https://lon.identity.api.rackspacecloud.com', :authenticate_v1
    assert_method 'https://lon.identity.api.rackspacecloud.com/v1', :authenticate_v1
    assert_method 'https://lon.identity.api.rackspacecloud.com/v1.1', :authenticate_v1
    assert_method 'https://lon.identity.api.rackspacecloud.com/v2.0', :authenticate_v2
  end

  tests('authentication v1') do
    pending if Fog.mocking?

    tests('variables populated') do
      @service = Fog::Rackspace::Databases.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v1.0'
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(false, "path populated") { @service.instance_variable_get("@uri").nil? }
      returns(true, "identity_service was not used") { @service.instance_variable_get("@identity_service").nil? }
      @service.flavors
    end
    tests('custom endpoint') do
      @service = Fog::Rackspace::Databases.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v1.0',
        :rackspace_database_url => 'https://my-custom-endpoint.com'
        returns(false, "auth token populated") { @service.send(:auth_token).nil? }
        returns(true, "uses custom endpoint") { (@service.instance_variable_get("@uri").host =~ /my-custom-endpoint\.com/) != nil }
    end
  end

  tests('authentication v2') do
    pending if Fog.mocking?

    tests('variables populated').succeeds do
      @service = Fog::Rackspace::Databases.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0', :connection_options => { :ssl_verify_peer => true }
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(false, "path populated") { @service.instance_variable_get("@uri").nil? }

      identity_service = @service.instance_variable_get("@identity_service")
      returns(false, "identity service was used") { identity_service.nil? }
      returns(true, "connection_options are passed") { identity_service.instance_variable_get("@connection_options").key?(:ssl_verify_peer) }
      @service.flavors
    end
    tests('dfw region').succeeds do
      @service = Fog::Rackspace::Databases.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0', :rackspace_region => :dfw
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true) { (@service.instance_variable_get("@uri").host =~ /dfw/) != nil }
      @service.flavors
    end
    tests('ord region').succeeds do
      @service = Fog::Rackspace::Databases.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0', :rackspace_region => :ord
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true) { (@service.instance_variable_get("@uri").host =~ /ord/) != nil }
      @service.flavors
    end
    tests('custom endpoint') do
      @service = Fog::Rackspace::Databases.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0',
        :rackspace_database_url => 'https://my-custom-endpoint.com'
        returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
        returns(true, "uses custom endpoint") { (@service.instance_variable_get("@uri").host =~ /my-custom-endpoint\.com/) != nil }
    end
  end

  tests('default auth') do
    pending if Fog.mocking?

    tests('no params').succeeds do
      @service = Fog::Rackspace::Databases.new :rackspace_region => nil
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true) { (@service.instance_variable_get("@uri").host =~ /dfw/) != nil }
      @service.flavors
    end
    tests('specify old contstant style service endoint').succeeds do
      @service = Fog::Rackspace::Databases.new :rackspace_endpoint => Fog::Rackspace::Databases::ORD_ENDPOINT
      returns(true) { (@service.instance_variable_get("@uri").to_s =~ /#{Fog::Rackspace::Databases::ORD_ENDPOINT}/ ) != nil }
      @service.flavors
    end
    tests('specify region').succeeds do
      @service = Fog::Rackspace::Databases.new :rackspace_region => :ord
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true) { (@service.instance_variable_get("@uri").host =~ /ord/ ) != nil }
      @service.flavors
    end
    tests('custom endpoint') do
      @service = Fog::Rackspace::Databases.new :rackspace_database_url => 'https://my-custom-endpoint.com'
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true, "uses custom endpoint") { (@service.instance_variable_get("@uri").host =~ /my-custom-endpoint\.com/) != nil }
    end
  end

  tests('reauthentication') do
    pending if Fog.mocking?

    tests('should reauth with valid credentials') do
      @service = Fog::Rackspace::Databases.new
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      @service.instance_variable_set("@auth_token", "bad_token")
      returns(200) { @service.list_flavors.status }
    end
    tests('should terminate with incorrect credentials') do
      raises(Excon::Errors::Unauthorized) { Fog::Rackspace::Databases.new :rackspace_api_key => 'bad_key' }
    end
  end

  @service = Fog::Rackspace::Databases.new

  tests('#flavors').succeeds do
    data = @service.flavors
    returns(true) { data.is_a? Array }
  end

  tests('#instances').succeeds do
    data = @service.instances
    returns(true) { data.is_a? Array }
  end

  tests('#databases').succeeds do
    data = @service.databases
    returns(true) { data.is_a? Array }
  end

  tests('#users').succeeds do
    data = @service.users
    returns(true) { data.is_a? Array }
  end

end
