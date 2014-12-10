Shindo.tests('Fog::Rackspace::Queues', ['rackspace']) do

  def assert_method(url, method)
    @service.instance_variable_set "@rackspace_auth_url", url
    returns(method) { @service.send :authentication_method }
  end

  tests('#authentication_method') do
    @service = Fog::Rackspace::Queues.new

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
    raises(Fog::Errors::NotImplemented) do
      @service = Fog::Rackspace::Queues.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v1.0'
    end
  end

  tests('authentication v2') do
    tests('variables populated').succeeds do
      @service = Fog::Rackspace::Queues.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0', :connection_options => { :ssl_verify_peer => true }
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(false, "path populated") { @service.instance_variable_get("@uri").nil? }

      identity_service = @service.instance_variable_get("@identity_service")
      returns(false, "identity service was used") { identity_service.nil? }
      returns(true, "connection_options are passed") { identity_service.instance_variable_get("@connection_options").key?(:ssl_verify_peer) }
      @service.queues
    end
    tests('dfw region').succeeds do
      #We consistently use DFW as our default but queues doesn't have a DFW default region yet.
      # We can enable this test once they have a DFW region (which they will)
      pending
      @service = Fog::Rackspace::Queues.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0', :rackspace_region => :dfw
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true) { (@service.instance_variable_get("@uri").host =~ /dfw/) != nil }
      @service.queues
    end
    tests('ord region').succeeds do
      @service = Fog::Rackspace::Queues.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0', :rackspace_region => :ord
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true) { (@service.instance_variable_get("@uri").host =~ /ord/) != nil }
      @service.queues
    end
  end

  tests('default auth') do
    tests('no params').succeeds do
      #We consistently use DFW as our default but queues doesn't have a DFW default region yet.
      # We can enable this test once they have a DFW region (which they will)
      pending
      @service = Fog::Rackspace::Queues.new
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true) { (@service.instance_variable_get("@uri").host =~ /dfw/) != nil }
      @service.queues
    end
    tests('specify region').succeeds do
      @service = Fog::Rackspace::Queues.new :rackspace_region => :ord
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true) { (@service.instance_variable_get("@uri").host =~ /ord/ ) != nil }
      @service.queues
    end
  end

  tests('reauthentication') do
    @service = Fog::Rackspace::Queues.new
    returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
    @service.instance_variable_set("@auth_token", "bad_token")
    returns(true, 'list queues call succeeds') { [200, 204].include?(@service.list_queues.status) }
  end

  @service = Fog::Rackspace::Queues.new

  tests('#queues').succeeds do
    data = @service.queues
    returns(true) { data.is_a? Array }
  end

  tests('client_id') do
    tests('should generate uuid if a client id is not provided').succeeds do
      pending unless Fog::UUID.supported?
      service = Fog::Rackspace::Queues.new
      service.client_id =~ /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
    end
    tests('should use specified uuid').succeeds do
      pending unless Fog::UUID.supported?
      my_uuid = Fog::UUID.uuid
      service = Fog::Rackspace::Queues.new :rackspace_queues_client_id => my_uuid
      service.client_id == my_uuid
    end

  end

end
