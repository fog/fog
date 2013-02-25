Shindo.tests('Fog::CDN::Rackspace', ['rackspace']) do

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
        returns(nil, "CDN is not enabled") { container_meta_attributes['X-CDN-Enabled'] }
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