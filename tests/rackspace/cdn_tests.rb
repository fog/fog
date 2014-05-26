Shindo.tests('Fog::CDN::Rackspace', ['rackspace']) do

  def assert_method(url, method)
    @service.instance_variable_set "@rackspace_auth_url", url
    returns(method) { @service.send :authentication_method }
  end

  tests('#authentication_method') do
    @service = Fog::CDN::Rackspace.new

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

    tests('variables populated').succeeds do
      @service = Fog::CDN::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v1.0'
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(false, "path populated") { @service.instance_variable_get("@uri").path.nil? }
      returns(true, "identity_service was not used") { @service.instance_variable_get("@identity_service").nil? }
      @service.get_containers
    end
    tests('custom endpoint') do
      @service = Fog::CDN::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v1.0',
        :rackspace_cdn_url => 'https://my-custom-cdn-endpoint.com'
        returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
        returns(true, "uses custom endpoint") { (@service.instance_variable_get("@uri").host =~ /my-custom-cdn-endpoint\.com/) != nil }
    end
  end

  tests('authentication v2') do
    pending if Fog.mocking?

    tests('variables populated').succeeds do
      @service = Fog::CDN::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0', :connection_options => { :ssl_verify_peer => true }
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(false, "path populated") { @service.instance_variable_get("@uri").path.nil? }
      identity_service = @service.instance_variable_get("@identity_service")
      returns(false, "identity service was used") { identity_service.nil? }
      returns(true, "connection_options are passed") { identity_service.instance_variable_get("@connection_options").key?(:ssl_verify_peer) }

      @service.get_containers
    end
    tests('dfw region').succeeds do
      @service = Fog::CDN::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0', :rackspace_region => :dfw
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true) { (@service.instance_variable_get("@uri").host =~ /cdn1/) != nil }
      @service.get_containers
    end
    tests('ord region').succeeds do
      @service = Fog::CDN::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0', :rackspace_region => :ord
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true) { (@service.instance_variable_get("@uri").host =~ /cdn2/) != nil }
      @service.get_containers
    end
    tests('custom endpoint') do
      @service = Fog::CDN::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0',
        :rackspace_cdn_url => 'https://my-custom-cdn-endpoint.com'
        returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
        returns(true, "uses custom endpoint") { (@service.instance_variable_get("@uri").host =~ /my-custom-cdn-endpoint\.com/) != nil }
    end
  end

  tests('default auth') do
    pending if Fog.mocking?

    tests('no params').succeeds do
      @service = Fog::CDN::Rackspace.new :rackspace_region => nil
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true, "uses DFW") { (@service.instance_variable_get("@uri").host =~ /cdn1/) != nil }
      @service.get_containers
    end

    tests('specify region').succeeds do
      @service = Fog::CDN::Rackspace.new :rackspace_region => :ord
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true) { (@service.instance_variable_get("@uri").host =~ /cdn2/) != nil }
      @service.get_containers
    end

    tests('custom endpoint') do
      @service = Fog::CDN::Rackspace.new :rackspace_cdn_url => 'https://my-custom-cdn-endpoint.com'
        returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
        returns(true, "uses custom endpoint") { (@service.instance_variable_get("@uri").host =~ /my-custom-cdn-endpoint\.com/) != nil }
    end
  end

  tests('reauthentication') do
    pending if Fog.mocking?

    tests('should reauth with valid credentials') do
      @service = Fog::CDN::Rackspace.new  :rackspace_region => :ord
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      @service.instance_variable_set("@auth_token", "bad-token")
      returns(true) { [200, 204].include? @service.get_containers.status }
    end
    tests('should terminate with incorrect credentials') do
      raises(Excon::Errors::Unauthorized) { Fog::CDN::Rackspace.new :rackspace_api_key => 'bad_key' }
    end
  end

  pending if Fog.mocking?

  def container_meta_attributes
    @cdn.head_container(@directory.key).headers
  end

  def clear_metadata
    @instance.metadata.tap do |metadata|
      metadata.each_pair {|k, v| metadata[k] = nil }
    end
  end

  directory_attributes = {
    # Add a random suffix to prevent collision
    :key => "fogfilestests-#{rand(65536)}"
  }

  @directory = Fog::Storage[:rackspace].directories.create(directory_attributes)
  @cdn = @directory.service.cdn

  begin
    tests('publish_container').succeeds do
      returns("False", "CDN is not enabled") { container_meta_attributes['X-CDN-Enabled'] }
      urls = @cdn.publish_container @directory
      returns(true, "hash contains expected urls") { Fog::CDN::Rackspace::Base::URI_HEADERS.values.all? { |url_type| urls[url_type] } }
      returns("True", "CDN is enabled") { container_meta_attributes['X-Cdn-Enabled'] }
    end

    tests('urls') do
      tests('CDN enabled container').returns(false) do
        @cdn.publish_container @directory
        @cdn.urls(@directory).empty?
      end
      tests('Non-CDN enabled container').returns(true) do
        @cdn.publish_container @directory, false
        @cdn.urls(@directory).empty?
      end
      tests('Non-existent container').returns(true) do
        non_existent_container = Fog::Storage::Rackspace::Directory.new :key => "non-existent"
        @cdn.urls(non_existent_container).empty?
      end
    end

    tests('urls_from_headers') do
      headers = {
        "X-Cdn-Streaming-Uri"=>"http://168e307d41afe64f1a62-d1e9259b2132e81da48ed3e1e802ef22.r2.stream.cf1.rackcdn.com",
        "X-Cdn-Uri"=>"http://6e8f4bf5125c9c2e4e3a-d1e9259b2132e81da48ed3e1e802ef22.r2.cf1.rackcdn.com",
        "Date"=>"Fri, 15 Feb 2013 18:36:41 GMT",
        "Content-Length"=>"0",
        "X-Trans-Id"=>"tx424df53b79bc43fe994d3cec0c4d2d8a",
        "X-Ttl"=>"3600",
        "X-Cdn-Ssl-Uri"=>"https://f83cb7d39e0b9ff9581b-d1e9259b2132e81da48ed3e1e802ef22.ssl.cf1.rackcdn.com",
        "X-Cdn-Ios-Uri"=>"http://a590286a323fec6aed22-d1e9259b2132e81da48ed3e1e802ef22.iosr.cf1.rackcdn.com",
        "X-Cdn-Enabled"=>"True",
        "Content-Type"=>"text/html; charset=UTF-8",
        "X-Log-Retention"=>"False"
      }

        urls = @cdn.send(:urls_from_headers, headers)
        returns(4) { urls.size }
        returns("http://168e307d41afe64f1a62-d1e9259b2132e81da48ed3e1e802ef22.r2.stream.cf1.rackcdn.com") { urls[:streaming_uri] }
        returns("http://6e8f4bf5125c9c2e4e3a-d1e9259b2132e81da48ed3e1e802ef22.r2.cf1.rackcdn.com") { urls[:uri] }
        returns("https://f83cb7d39e0b9ff9581b-d1e9259b2132e81da48ed3e1e802ef22.ssl.cf1.rackcdn.com") { urls[:ssl_uri] }
        returns("http://a590286a323fec6aed22-d1e9259b2132e81da48ed3e1e802ef22.iosr.cf1.rackcdn.com") { urls[:ios_uri] }
    end

    tests('purge') do
      pending
    end

  ensure
    @directory.destroy if @directory
  end
end
