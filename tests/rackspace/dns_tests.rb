Shindo.tests('Fog::DNS::Rackspace', ['rackspace']) do

  def assert_method(url, method)
    @service.instance_variable_set "@rackspace_auth_url", url
    returns(method) { @service.send :authentication_method }
  end

  tests('#authentication_method') do
    @service = Fog::DNS::Rackspace.new

    assert_method nil, :authenticate_v2

    assert_method 'auth.api.rackspacecloud.com', :authenticate_v1 # chef's default auth endpoint

    assert_method 'https://identity.api.rackspacecloud.com', :authenticate_v1
    assert_method 'https://identity.api.rackspacecloud.com/v1', :authenticate_v1
    assert_method 'https://identity.api.rackspacecloud.com/v1.1', :authenticate_v1
    assert_method 'https://identity.api.rackspacecloud.com/v2.0', :authenticate_v2

    assert_method 'https://lon.identity.api.rackspacecloud.com', :authenticate_v1
    assert_method 'https://lon.identity.api.rackspacecloud.com/v1', :authenticate_v1
    assert_method 'https://lon.identity.api.rackspacecloud.com/v1.1', :authenticate_v1
    assert_method 'https://lon.identity.api.rackspacecloud.com/v2.0', :authenticate_v2
  end

  tests('legacy authentication') do
    pending if Fog.mocking?

    tests('variables populated').succeeds do
      @service = Fog::DNS::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v1.0'
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true, "contains tenant id") {  (@service.instance_variable_get("@uri").path =~ /\/v1\.0\/\d+$/) != nil} #dns does not error if tenant id is missing
      returns(false, "path populated") { @service.instance_variable_get("@uri").path.nil? }
      returns(true, "identity_service was not used") { @service.instance_variable_get("@identity_service").nil? }
      @service.list_domains
    end

    tests('custom endpoint') do
      @service = Fog::DNS::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v1.0',
        :rackspace_dns_url => 'https://my-custom-endpoint.com'
        returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
        returns(true, "uses custom endpoint") { (@service.instance_variable_get("@uri").host =~ /my-custom-endpoint\.com/) != nil }
    end
  end

  tests('current authentication') do
    pending if Fog.mocking?

    tests('variables populated').succeeds do
      @service = Fog::DNS::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0', :connection_options => { :ssl_verify_peer => true }
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(false, "path populated") { @service.instance_variable_get("@uri").host.nil? }
      returns(true, "contains tenant id") {  (@service.instance_variable_get("@uri").path =~ /\/v1\.0\/\d+$/) != nil} #dns does not error if tenant id is missing

      identity_service = @service.instance_variable_get("@identity_service")
      returns(false, "identity service was used") { identity_service.nil? }
      returns(true, "connection_options are passed") { identity_service.instance_variable_get("@connection_options").key?(:ssl_verify_peer) }
      @service.list_domains
    end
    tests('custom endpoint') do
      @service = Fog::DNS::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0',
        :rackspace_dns_url => 'https://my-custom-endpoint.com'
        returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
        returns(true, "uses custom endpoint") { (@service.instance_variable_get("@uri").host =~ /my-custom-endpoint\.com/) != nil }
    end
  end

  tests('default auth') do
    pending if Fog.mocking?

    tests('no params').succeeds do
      @service = Fog::DNS::Rackspace.new :rackspace_region => nil
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(false, "path populated") { @service.instance_variable_get("@uri").host.nil? }
      returns(true, "contains tenant id") {  (@service.instance_variable_get("@uri").path =~ /\/v1\.0\/\d+$/) != nil} #dns does not error if tenant id is missing
      @service.list_domains
    end
    tests('custom endpoint') do
      @service = Fog::DNS::Rackspace.new :rackspace_dns_url => 'https://my-custom-endpoint.com'
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true, "uses custom endpoint") { (@service.instance_variable_get("@uri").host =~ /my-custom-endpoint\.com/) != nil }
    end
  end

  tests('reauthentication') do
    pending if Fog.mocking?

    tests('should reauth with valid credentials') do
      @service = Fog::DNS::Rackspace.new
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      @service.instance_variable_set("@auth_token", "bad_token")
      returns(200) { @service.list_domains.status }
    end
    tests('should terminate with incorrect credentials') do
      raises(Excon::Errors::Unauthorized) { Fog::DNS::Rackspace.new :rackspace_api_key => 'bad_key' }
    end
  end

  tests('array_to_query_string') do
    pending if Fog.mocking?

    @service = Fog::DNS::Rackspace.new
    returns("") { @service.send(:array_to_query_string, nil) }
    returns("param1=1") { @service.send(:array_to_query_string, {:param1 => [1]}) }
    returns("param1=1") { @service.send(:array_to_query_string, {:param1 => 1}) }
    returns("param1=1,2") { @service.send(:array_to_query_string, {:param1 => [1,2]}) }
    returns("param1=1&param2=2") { @service.send(:array_to_query_string, {:param1 => [1], :param2 => [2]}) }
  end

end
