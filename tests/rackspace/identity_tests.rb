Shindo.tests('Fog::Rackspace::Identity', ['rackspace']) do

  tests('current authentication') do
    tests('variables populated').returns(200)  do
      @service = Fog::Rackspace::Identity.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0', :connection_options => {:ssl_verify_peer => true}
      returns(true, "auth token populated") { !@service.auth_token.nil? }
      returns(false, "path populated") { @service.instance_variable_get("@uri").host.nil? }
      returns(false, "service catalog populated") { @service.service_catalog.nil? }

      @service.list_tenants.status
    end
  end

  tests('reauthentication') do
    tests('should reauth with valid credentials') do
      @service = Fog::Rackspace::Identity.new  :rackspace_region => :ord
      returns(true, "auth token populated") { !@service.auth_token.nil? }
      @service.instance_variable_set("@auth_token", "bad-token")
      returns(true) { [200, 203].include? @service.list_tenants.status }
    end
    tests('should terminate with incorrect credentials') do
      raises(Excon::Errors::Unauthorized) { Fog::Rackspace::Identity.new :rackspace_api_key => 'bad_key' }
    end
  end

end
