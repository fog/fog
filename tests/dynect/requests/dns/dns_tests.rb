Shindo.tests('Dynect::dns | DNS requests', ['dynect', 'dns']) do

  shared_format = {
    'job_id' => Integer,
    'msgs' => [{
      'ERR_CD'  => Fog::Nullable::String,
      'INFO'    => String,
      'LVL'     => String,
      'SOURCE'  => String
    }],
    'status' => String
  }

  tests "success" do

    @dns = Fog::DNS[:dynect]
    @domain = generate_unique_domain
    @fqdn = "www.#{@domain}"

    post_session_format = shared_format.merge({
      'data' => {
        'token'   => String,
        'version' => String
      }
    })

    tests("post_session").formats(post_session_format) do
      @dns.post_session.body
    end

    post_zone_format = shared_format.merge({
      'data' => {
        'serial'        => Integer,
        'zone'          => String,
        'zone_type'     => String,
        'serial_style'  => String
      }
    })

    tests("post_zone('netops@#{@domain}', 3600, '#{@domain}')").formats(post_zone_format) do
      @dns.post_zone("netops@#{@domain}", 3600, @domain).body
    end

    get_zones_format = shared_format.merge({
      'data' => [String]
    })

    tests("get_zone").formats(get_zones_format) do
      @dns.get_zone.body
    end

    get_zone_format = shared_format.merge({
      'data' => {
        "serial"        => Integer,
        "serial_style"  => String,
        "zone"          => String,
        "zone_type"     => String
      }
    })

    tests("get_zone('zone' => '#{@domain}')").formats(get_zone_format) do
      @dns.get_zone('zone' => @domain).body
    end

    post_record_format = shared_format.merge({
      'data' => {
        'fqdn'        => String,
        'rdata'       => {
          'address' => String
        },
        'record_id'   => Integer,
        'record_type' => String,
        'ttl'         => Integer,
        'zone'        => String
      }
    })

    tests("post_record('A', '#{@domain}', '#{@fqdn}', 'address' => '1.2.3.4')").formats(post_record_format) do
      @dns.post_record('A', @domain, @fqdn, {'address' => '1.2.3.4'}).body
    end

    put_record_format = shared_format.merge({
      'data' => {
        'fqdn'        => String,
        'ARecords'    => [
          {
            'rdata'      => {
              'address'   => String
            }
          }
        ],
        'record_id'   => Integer,
        'record_type' => String,
        'ttl'         => Integer,
        'zone'        => String
      }
    })

    tests("put_record('A', '#{@domain}', '#{@fqdn}', 'address' => '1.2.3.4')").formats(post_record_format) do
      @dns.put_record('A', @domain, @fqdn, {'address' => '1.2.3.4'}).body
    end

    publish_zone_format = shared_format.merge({
      'data' => {
        'serial'        => Integer,
        'serial_style'  => String,
        'zone'          => String,
        'zone_type'     => String
      }
    })

    tests("put_zone('#{@domain}', 'publish' => true)").formats(publish_zone_format) do
      @dns.put_zone(@domain, 'publish' => true).body
    end

    freeze_zone_format = shared_format.merge({
      'data' => {}
    })

    tests("put_zone('#{@domain}', 'freeze' => true)").formats(freeze_zone_format) do
      @dns.put_zone(@domain, 'freeze' => true).body
    end

    thaw_zone_format = shared_format.merge({
      'data' => {}
    })

    tests("put_zone('#{@domain}', 'thaw' => true)").formats(thaw_zone_format) do
      @dns.put_zone(@domain, 'thaw' => true).body
    end

    get_node_list_format = shared_format.merge({
      'data' => [String]
    })

    tests("get_node_list('#{@domain}')").formats(get_node_list_format) do
      @dns.get_node_list(@domain).body
    end

    get_all_records_format = shared_format.merge({
      'data' => [String]
    })

    tests("get_all_records('#{@domain}')").formats(get_all_records_format) do
      @dns.get_all_records(@domain).body
    end

    get_records_format = shared_format.merge({
      'data' => [String]
    })

    tests("get_record('A', '#{@domain}', '#{@fqdn}')").formats(get_records_format) do
      data = @dns.get_record('A', @domain, @fqdn).body
      @record_id = data['data'].first.split('/').last
      data
    end

    sleep 5 unless Fog.mocking?

    @dns.post_record('CNAME', @domain, "cname.#{@fqdn}", {'cname' => "#{@fqdn}."})

    tests("get_record('ANY', '#{@domain}', 'cname.#{@fqdn}')").formats(get_records_format) do
      @dns.get_record('ANY', @domain, "cname.#{@fqdn}").body
    end

    get_record_format = shared_format.merge({
      'data' => {
        'zone' => String,
        'ttl' => Integer,
        'fqdn' => String,
        'record_type' => String,
        'rdata' => {
          'address' => String
        },
        'record_id' => Integer
      }
    })

    tests("get_record('A', '#{@domain}', '#{@fqdn}', 'record_id' => '#{@record_id}')").formats(get_record_format) do
      @dns.get_record('A', @domain, @fqdn, 'record_id' => @record_id).body
    end

    delete_record_format = shared_format.merge({
      'data' => {}
    })

    tests("delete_record('A', '#{@domain}', '#{@fqdn}', '#{@record_id}')").formats(delete_record_format) do
      @dns.delete_record('A', @domain, "#{@fqdn}", @record_id).body
    end

    delete_zone_format = shared_format.merge({
      'data' => {}
    })

    sleep 5 unless Fog.mocking?

    tests("delete_zone('#{@domain}')").formats(delete_zone_format) do
      @dns.delete_zone(@domain).body
    end

    tests("job handling") do
      pending unless Fog.mocking?

      old_mock_value = Excon.defaults[:mock]
      Excon.stubs.clear

      tests("returns final response from a complete job").returns({"status" => "success"}) do
        begin
          Excon.defaults[:mock] = true

          Excon.stub({:method => :post, :path => "/REST/Session"}, {:body=>"{\"status\": \"success\", \"data\": {\"token\": \"foobar\", \"version\": \"2.3.1\"}, \"job_id\": 150583906, \"msgs\": [{\"INFO\": \"login: Login successful\", \"SOURCE\": \"BLL\", \"ERR_CD\": null, \"LVL\": \"INFO\"}]}", :headers=>{"Content-Type"=>"application/json"}, :status=>200})

          Excon.stub({:method => :get, :path => "/REST/Zone/example.com"}, {:status => 307, :body => '/REST/Job/150576635', :headers => {'Content-Type' => 'text/html', 'Location' => '/REST/Job/150576635'}})
          Excon.stub({:method => :get, :path => "/REST/Job/150576635"}, {:status => 307, :body => '{"status":"success"}', :headers => {'Content-Type' => 'application/json'}})

          Fog::DNS::Dynect::Real.new.request(:method => :get, :path => "Zone/example.com").body
        ensure
          Excon.stubs.clear
          Excon.defaults[:mock] = old_mock_value
        end
      end

      tests("passes expects through when polling a job").returns({"status" => "success"}) do
        begin
          Excon.defaults[:mock] = true

          Excon.stub({:method => :post, :path => "/REST/Session"}, {:body=>"{\"status\": \"success\", \"data\": {\"token\": \"foobar\", \"version\": \"2.3.1\"}, \"job_id\": 150583906, \"msgs\": [{\"INFO\": \"login: Login successful\", \"SOURCE\": \"BLL\", \"ERR_CD\": null, \"LVL\": \"INFO\"}]}", :headers=>{"Content-Type"=>"application/json"}, :status=>200})

          Excon.stub({:method => :get, :path => "/REST/Zone/example.com"}, {:status => 307, :body => '/REST/Job/150576635', :headers => {'Content-Type' => 'text/html', 'Location' => '/REST/Job/150576635'}})
          Excon.stub({:method => :get, :path => "/REST/Job/150576635"}, {:status => 404, :body => '{"status":"success"}', :headers => {'Content-Type' => 'application/json'}})

          Fog::DNS::Dynect::Real.new.request(:method => :get, :expects => 404, :path => "Zone/example.com").body
        ensure
          Excon.stubs.clear
          Excon.defaults[:mock] = old_mock_value
        end
      end
    end
  end

  tests('failure') do
    tests("#auth_token with expired credentials").raises(Excon::Errors::BadRequest) do
      pending if Fog.mocking?
      @dns = Fog::DNS[:dynect]
      @dns.instance_variable_get(:@connection).stub(:request) { raise Excon::Errors::BadRequest.new('Expected(200) <=> Actual(400 Bad Request) request => {:headers=>{"Content-Type"=>"application/json", "API-Version"=>"2.3.1", "Auth-Token"=>"auth-token", "Host"=>"api2.dynect.net:443", "Content-Length"=>0}, :host=>"api2.dynect.net", :mock=>nil, :path=>"/REST/CNAMERecord/domain.com/www.domain.com", :port=>"443", :query=>nil, :scheme=>"https", :expects=>200, :method=>:get} response => #<Excon::Response:0x00000008478b98 @body="{"status": "failure", "data": {}, "job_id": 21326025, "msgs": [{"INFO": "login: Bad or expired credentials", "SOURCE": "BLL", "ERR_CD": "INVALID_DATA", "LVL": "ERROR"}, {"INFO": "login: There was a problem with your credentials", "SOURCE": "BLL", "ERR_CD": null, "LVL": "INFO"}]}", @headers={"Server"=>"nginx/0.7.67", "Date"=>"Thu, 08 Sep 2011 20:04:21 GMT", "Content-Type"=>"application/json", "Transfer-Encoding"=>"chunked", "Connection"=>"keep-alive"}, @status=400>') }
      @dns.instance_variable_get(:@connection).should_receive(:request).exactly(2).times
      @dns.auth_token
    end

    tests("#auth_token with inactivity logout").raises(Excon::Errors::BadRequest) do
      pending if Fog.mocking?
      @dns = Fog::DNS[:dynect]
      @dns.instance_variable_get(:@connection).stub(:request) { raise Excon::Errors::BadRequest.new('Expected(200) <=> Actual(400 Bad Request) request => {:headers=>{"Content-Type"=>"application/json", "API-Version"=>"2.3.1", "Auth-Token"=>"auth-token", "Host"=>"api2.dynect.net:443", "Content-Length"=>0}, :host=>"api2.dynect.net", :mock=>nil, :path=>"/REST/CNAMERecord/domain.com/www.domain.com", :port=>"443", :query=>nil, :scheme=>"https", :expects=>200, :method=>:get} response => #<Excon::Response:0x00000008478b98 @body="{"status": "failure", "data": {}, "job_id": 21326025, "msgs": [{"INFO": "login: inactivity logout", "SOURCE": "BLL", "ERR_CD": "INVALID_DATA", "LVL": "ERROR"}, {"INFO": "login: There was a problem with your credentials", "SOURCE": "BLL", "ERR_CD": null, "LVL": "INFO"}]}", @headers={"Server"=>"nginx/0.7.67", "Date"=>"Thu, 08 Sep 2011 20:04:21 GMT", "Content-Type"=>"application/json", "Transfer-Encoding"=>"chunked", "Connection"=>"keep-alive"}, @status=400>') }
      @dns.instance_variable_get(:@connection).should_receive(:request).exactly(2).times
      @dns.auth_token
    end
  end
end
