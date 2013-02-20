Shindo.tests('Fog::CDN::Rackspace', ['rackspace']) do
  
  def assert_method(url, method)
    @service.instance_variable_set "@rackspace_auth_url", url
    returns(method) { @service.send :authentication_method }
  end

  tests('#authentication_method') do
    @service = Fog::CDN::Rackspace.new
    assert_method nil, :authenticate_v2
    
    assert_method 'https://identity.api.rackspacecloud.com/v1', :authenticate_v1
    assert_method 'https://identity.api.rackspacecloud.com/v1.1', :authenticate_v1    
    assert_method 'https://identity.api.rackspacecloud.com/v2.0', :authenticate_v2
    
    assert_method 'https://lon.identity.api.rackspacecloud.com/v1', :authenticate_v1
    assert_method 'https://lon.identity.api.rackspacecloud.com/v1.1', :authenticate_v1
    assert_method 'https://lon.identity.api.rackspacecloud.com/v2.0', :authenticate_v2
  end
  
  tests('authentication v1') do
    pending if Fog.mocking?
    @service = Fog::CDN::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v1.0'

    tests('variables populated') do
      returns(false, "auth token populated") { @service.instance_variable_get("@auth_token").nil? }
      returns(false, "path populated") { @service.instance_variable_get("@uri").path.nil? }
      returns(true, "identity_service was not used") { @service.instance_variable_get("@identity_service").nil? }    
    end
    tests('custom endpoint') do
      @service = Fog::CDN::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v1.0', 
        :rackspace_cdn_url => 'https://my-custom-cdn-endpoint.com'
        returns(true, "uses custom endpoint") { (@service.instance_variable_get("@uri").host =~ /my-custom-cdn-endpoint\.com/) != nil }
    end
  end

  tests('authentation v2') do
    pending if Fog.mocking?
    @service = Fog::CDN::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0'
    
    tests('variables populated') do
      returns(false, "auth token populated") { @service.instance_variable_get("@auth_token").nil? }
      returns(false, "path populated") { @service.instance_variable_get("@uri").path.nil? }
      returns(false, "identity service was used") { @service.instance_variable_get("@identity_service").nil? }    
    end
    tests('dfw region') do
      @service = Fog::CDN::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0', :rackspace_region => :dfw
      returns(true) { (@service.instance_variable_get("@uri").host =~ /cdn1/) != nil }
    end
    tests('ord region') do
      @service = Fog::CDN::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0', :rackspace_region => :ord
      returns(true) { (@service.instance_variable_get("@uri").host =~ /cdn2/) != nil }
    end
    tests('custom endpoint') do
      @service = Fog::CDN::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0', 
        :rackspace_cdn_url => 'https://my-custom-cdn-endpoint.com'
        returns(true, "uses custom endpoint") { (@service.instance_variable_get("@uri").host =~ /my-custom-cdn-endpoint\.com/) != nil }
    end
  end
  
  tests('default auth') do
    pending if Fog.mocking?
    
    tests('no params') do
      @service = Fog::CDN::Rackspace.new
      returns(true, "uses DFW") { (@service.instance_variable_get("@uri").host =~ /cdn1/) != nil }
    end
    
    tests('specify region') do
      @service = Fog::CDN::Rackspace.new :rackspace_region => :ord
      returns(true) { (@service.instance_variable_get("@uri").host =~ /cdn2/) != nil }
    end
    
    tests('custom endpoint') do
      @service = Fog::CDN::Rackspace.new :rackspace_cdn_url => 'https://my-custom-cdn-endpoint.com'
        returns(true, "uses custom endpoint") { (@service.instance_variable_get("@uri").host =~ /my-custom-cdn-endpoint\.com/) != nil }
    end
  end
end