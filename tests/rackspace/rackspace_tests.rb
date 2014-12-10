Shindo.tests('Fog::Rackspace', ['rackspace']) do

  tests('normalize_url') do
    tests('should return nil if endpoint is nil').returns(nil) do
      Fog::Rackspace.normalize_url nil
    end
    tests('should remove trailing spaces').returns("https://dfw.blockstorage.api.rackspacecloud.com/v1") do
      Fog::Rackspace.normalize_url "https://dfw.blockstorage.api.rackspacecloud.com/v1 "
    end
    tests('should remove trailing /').returns("https://dfw.blockstorage.api.rackspacecloud.com/v1") do
      Fog::Rackspace.normalize_url "https://dfw.blockstorage.api.rackspacecloud.com/v1/"
    end
    tests('should downcase url').returns("https://dfw.blockstorage.api.rackspacecloud.com/v1") do
      Fog::Rackspace.normalize_url "HTTPS://DFW.BLOCKSTORAGE.API.RACKSPACECLOUD.COM/V1"
    end
    tests('show do all three').returns("https://dfw.blockstorage.api.rackspacecloud.com/v1") do
      Fog::Rackspace.normalize_url "HTTPS://DFW.BLOCKSTORAGE.API.RACKSPACECLOUD.COM/V1/ "
    end
  end

  tests('json_response?') do
    returns(false, "nil") { Fog::Rackspace.json_response?(nil) }

    tests('missing header').returns(false) do
      response = Excon::Response.new
      response.headers = nil #maybe this is a forced case
      returns(true) { response.headers.nil? }
      Fog::Rackspace.json_response?(response)
    end

    tests('nil Content-Type header').returns(false) do
      response = Excon::Response.new
      response.headers['Content-Type'] = nil
      Fog::Rackspace.json_response?(response)
    end

    tests('text/html Content-Type header').returns(false) do
      response = Excon::Response.new
      response.headers['Content-Type'] = 'text/html'
      Fog::Rackspace.json_response?(response)
    end

    tests('application/json Content-Type header').returns(true) do
      response = Excon::Response.new
      response.headers['Content-Type'] = 'application/json'
      Fog::Rackspace.json_response?(response)
    end

    tests('APPLICATION/JSON Content-Type header').returns(true) do
      response = Excon::Response.new
      response.headers['Content-Type'] = 'APPLICATION/JSON'
      Fog::Rackspace.json_response?(response)
    end
  end

end
