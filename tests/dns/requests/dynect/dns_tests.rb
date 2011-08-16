Shindo.tests('Dynect::dns | DNS requests', ['dynect', 'dns']) do

  pending if Fog.mocking?

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
      @dns.post_record('A', @domain, @fqdn, {'address' => '1.2.3.4'}, {}).body
    end

    put_zone_format = shared_format.merge({
      'data' => {
        'serial'        => Integer,
        'serial_style'  => String,
        'zone'          => String,
        'zone_type'     => String
      }
    })

    tests("put_zone('#{@domain}', :publish => true)").formats(put_zone_format) do
      @dns.put_zone(@domain, :publish => true).body
    end

    get_node_list_format = shared_format.merge({
      'data' => [String]
    })

    tests("get_node_list('#{@domain}')").formats(get_node_list_format) do
      @dns.get_node_list(@domain).body
    end

    get_records_format = shared_format.merge({
      'data' => [String]
    })

    tests("get_record('A', '#{@domain}', '#{@fqdn}')").formats(get_records_format) do
      data = @dns.get_record('A', @domain, @fqdn).body
      @record_id = data['data'].first.split('/').last
      data
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

    tests("delete_zone('#{@domain}')").formats(delete_zone_format) do
      @dns.delete_zone(@domain).body
    end

  end
end
