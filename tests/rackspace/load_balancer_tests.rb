Shindo.tests('Fog::Rackspace::LoadBalancers', ['rackspace']) do

  def assert_method(url, method)
    @service.instance_variable_set "@rackspace_auth_url", url
    returns(method) { @service.send :authentication_method }
  end

  tests('#authentication_method') do
    @service = Fog::Rackspace::LoadBalancers.new

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
    @service = Fog::Rackspace::LoadBalancers.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v1.0'

    tests('variables populated') do
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(false, "path populated") { @service.instance_variable_get("@uri").path.nil? }
      returns(true, "identity_service was not used") { @service.instance_variable_get("@identity_service").nil? }
    end

    tests('custom endpoint') do
      @service = Fog::Rackspace::LoadBalancers.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v1.0',
        :rackspace_load_balancers_url => 'https://my-custom-endpoint.com'
        returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
        returns(true, "uses custom endpoint") { (@service.instance_variable_get("@uri").host =~ /my-custom-endpoint\.com/) != nil }
    end
  end

  tests('current authentation') do
    pending if Fog.mocking?
    @service = Fog::Rackspace::LoadBalancers.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0'

    tests('variables populated') do
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(false, "path populated") { @service.instance_variable_get("@uri").host.nil? }
      returns(false, "identity service was used") { @service.instance_variable_get("@identity_service").nil? }
    end
    tests('dfw region') do
      @service = Fog::Rackspace::LoadBalancers.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0', :rackspace_region => :dfw
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true) { (@service.instance_variable_get("@uri").host =~ /dfw/) != nil }
    end
    tests('ord region') do
      @service = Fog::Rackspace::LoadBalancers.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0', :rackspace_region => :ord
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true) { (@service.instance_variable_get("@uri").host =~ /ord/) != nil }
    end
    tests('custom endpoint') do
      @service = Fog::Rackspace::LoadBalancers.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0',
        :rackspace_load_balancers_url => 'https://my-custom-endpoint.com'
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true, "uses custom endpoint") { (@service.instance_variable_get("@uri").host =~ /my-custom-endpoint\.com/) != nil }
    end
  end

  tests('default auth') do
    pending if Fog.mocking?

    tests('no params') do
      @service = Fog::Rackspace::LoadBalancers.new
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true) { (@service.instance_variable_get("@uri").host =~ /dfw/) != nil }
    end
    tests('specify region') do
      @service = Fog::Rackspace::LoadBalancers.new :rackspace_region => :ord
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true) { (@service.instance_variable_get("@uri").host =~ /ord/ ) != nil }
    end
    tests('custom endpoint') do
      @service = Fog::Rackspace::LoadBalancers.new :rackspace_load_balancers_url => 'https://my-custom-endpoint.com'
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true, "uses custom endpoint") { (@service.instance_variable_get("@uri").host =~ /my-custom-endpoint\.com/) != nil }
    end
  end

  pending if Fog.mocking?

  @service = Fog::Rackspace::LoadBalancers.new

  tests('#algorithms').succeeds do
    data = @service.algorithms
    returns(true) { data.is_a? Array }
    returns(true) { data.first.is_a? String }
  end

  tests('#protocols').succeeds do
    data = @service.protocols
    returns(true) { data.is_a? Array }
  end

  tests('#usage').succeeds do
    @service.usage
  end
end
