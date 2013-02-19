Shindo.tests('Fog::CDN::Rackspace', ['rackspace']) do

  pending if Fog.mocking?
  
  def assert_method(url, method)
    @service.instance_variable_set "@rackspace_auth_url", method
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
  
  tests('legacy authentication') do
    pending if Fog.mocking?
    @service = Fog::CDN::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v1.0'

    tests('variables populated') do
      returns(false, "auth token populated") { @service.instance_variable_get("@auth_token").nil? }
      returns(false, "path populated") { @service.instance_variable_get("@path").nil? }
      returns(true, "identity_service was not used") { @service.instance_variable_get("@identity_service").nil? }    
    end
  end

  tests('current authentation') do
    pending if Fog.mocking?
    @service = Fog::CDN::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0'
    
    tests('variables populated') do
      returns(false, "auth token populated") { @service.instance_variable_get("@auth_token").nil? }
      returns(false, "path populated") { @service.instance_variable_get("@path").nil? }
      returns(false, "identity service was used") { @service.instance_variable_get("@identity_service").nil? }    
    end
    tests('dfw region') do
      @service = Fog::CDN::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0', :rackspace_region => :dfw
      puts @service.instance_variable_get("@host") 
      returns(true) { (@service.instance_variable_get("@host") =~ /cdn1/) != nil }
    end
    tests('ord region') do
      @service = Fog::CDN::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0', :rackspace_region => :ord
      returns(true) { (@service.instance_variable_get("@host") =~ /cdn2/) != nil }

    end
  end
  
  
end