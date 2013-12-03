Shindo.tests('Fog::Rackspace::Service', ['rackspace']) do

  tests('process_response') do
    @service = Fog::Rackspace::Service.new

    tests('nil').returns(nil) do
      @service.send(:process_response, nil)
    end

    tests('response missing body').returns(nil) do
      response = Excon::Response.new
      response.body = nil
      @service.send(:process_response, response)
    end

    tests('processes body').returns({'a'=>2, 'b'=>3}) do
      response = Excon::Response.new
      response.headers['Content-Type'] = "application/json"
      response.body = "{\"a\":2,\"b\":3}"
      @service.send(:process_response, response)
      response.body
    end

    tests('process body with hash').returns({:a=>2, :b=>3}) do
      response = Excon::Response.new
      response.headers['Content-Type'] = "application/json"
      response.body = {:a=>2, :b=>3}
      @service.send(:process_response, response)
      response.body
    end

    tests('handles malformed json').returns({}) do
      response = Excon::Response.new
      response.headers['Content-Type'] = "application/json"
      response.body = "I am totally not json"
      @service.send(:process_response, response)
      response.body
    end

  end

  tests('headers') do
    # adding an implementation for auth_token to service instance. Normally this would come from a subclass.
    def @service.auth_token
      "my_auth_token"
    end

    HEADER_HASH = {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json',
      'X-Auth-Token' => @service.auth_token
    }.freeze

    tests('without options').returns(HEADER_HASH) do
       @service.send(:headers)
    end

    tests('with options not containing :header key').returns(HEADER_HASH) do
       @service.send(:headers, {:a => 3})
    end

    tests('with options containing :header key').returns(HEADER_HASH.merge(:a => 3)) do
       @service.send(:headers, :headers => {:a => 3})
    end
  end

  tests('request_params') do
    REQUEST_HASH = {
      :path=>"/endpoint/my_service",
      :headers=>{"Content-Type"=>"application/json", "Accept"=>"application/json", "X-Auth-Token"=>"my_auth_token"},
    }.freeze

    uri = URI.parse("http://fog.io/endpoint")
    @service.instance_variable_set("@uri", uri)
    params = {:path => 'my_service'}

    tests('returns request hash').returns(REQUEST_HASH) do
      @service.send(:request_params, params)
    end
  end

end
