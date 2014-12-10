Shindo.tests('Fog::CDN[:rackspace] | CDN requests', ['rackspace']) do

  @container_format = [String]

  @containers_format = [{
    "cdn_ios_uri" => String,
    "log_retention" => Fog::Boolean,
    "ttl" => Fixnum,
    "cdn_streaming_uri" => String,
    "cdn_enabled" => Fog::Boolean,
    "name" => String,
    "cdn_ssl_uri" => String,
    "cdn_uri" => String
  }]

  @container_headers = {
    "Content-Length" => String,
    "X-Cdn-Enabled" => String,
    "X-Log-Retention" => String,
    "X-Cdn-Ios-Uri" => String,
    "X-Ttl" => String,
    "X-Cdn-Uri" => String,
    "X-Cdn-Ssl-Uri" => String,
    "X-Cdn-Streaming-Uri" => String,
    "X-Trans-Id" => String,
    "Date" => String
  }

  begin
    unless Fog.mocking?
      @directory = Fog::Storage[:rackspace].directories.create(:key => 'fogcontainertests')
      @file = @directory.files.create(:key => 'fog_object', :body => lorem_file)
    end

    tests('success') do

      tests("#put_container('fogcontainertests')").succeeds do
        Fog::CDN[:rackspace].put_container('fogcontainertests', {'X-CDN-Enabled' => true })
      end

      tests("#get_containers").formats(@containers_format) do
        Fog::CDN[:rackspace].get_containers.body
      end

      tests("#head_container('fogcontainertests')").formats(@container_headers) do
        Fog::CDN[:rackspace].head_container('fogcontainertests').headers
      end

      tests("#post_container('fogcontainertests')").succeeds do
        Fog::CDN[:rackspace].post_container('fogcontainertests', 'X-TTL' => 5000)
      end

      #NOTE: you are only allow 25 object purges per day. If this fails, you may be over the limit
      tests("#delete_object('fog_object')").succeeds do
        Fog::CDN[:rackspace].delete_object('fogcontainertests', 'fog_object')
      end
    end
  ensure
    unless Fog.mocking?
      @file.destroy if @file
      @directory.destroy if @directory
    end
  end

  tests('failure') do

    tests("#head_container('missing_container')").raises(Fog::Storage::Rackspace::NotFound) do
      Fog::CDN[:rackspace].head_container('missing_container')
    end

    tests("#post_container('missing_container')").raises(Fog::Storage::Rackspace::NotFound) do
      Fog::CDN[:rackspace].post_container('missing_container', 'X-TTL' => 5000)
    end
  end
end
