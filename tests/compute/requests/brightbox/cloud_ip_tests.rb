Shindo.tests('Fog::Compute[:brightbox] | cloud ip requests', ['brightbox']) do

  tests('success') do

    unless Fog.mocking?
      @server = Fog::Compute[:brightbox].servers.create(compute_providers[:brightbox][:server_attributes])
    end

    tests("#create_cloud_ip").formats(Brightbox::Compute::Formats::Full::CLOUD_IP) do
      pending if Fog.mocking?
      data = Fog::Compute[:brightbox].create_cloud_ip
      @cloud_ip_id = data["id"]
      data
    end

    tests("#list_cloud_ips").formats(Brightbox::Compute::Formats::Collection::CLOUD_IPS) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].list_cloud_ips
    end

    tests("#get_cloud_ip('#{@cloud_ip_id}')").formats(Brightbox::Compute::Formats::Full::CLOUD_IP) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_cloud_ip(@cloud_ip_id)
    end

    unless Fog.mocking?
      @server.wait_for { ready? }
      map_options = {:interface => @server.interfaces.first["id"]}
    end

    tests("#map_cloud_ip('#{@cloud_ip_id}', #{map_options.inspect})").formats(Brightbox::Compute::Formats::Full::CLOUD_IP) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].map_cloud_ip(@cloud_ip_id, map_options)
    end

    unless Fog.mocking?
      Fog::Compute[:brightbox].cloud_ips.get(@cloud_ip_id).wait_for { mapped? }
    end

    tests("#unmap_cloud_ip('#{@cloud_ip_id}')").formats(Brightbox::Compute::Formats::Full::CLOUD_IP) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].unmap_cloud_ip(@cloud_ip_id)
    end

    tests("#destroy_cloud_ip('#{@cloud_ip_id}')").formats(Brightbox::Compute::Formats::Full::CLOUD_IP) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].destroy_cloud_ip(@cloud_ip_id)
    end

    unless Fog.mocking?
      @server.destroy
    end

  end

  tests('failure') do

    tests("#get_cloud_ip('cip-00000')").raises(Excon::Errors::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_cloud_ip('cip-00000')
    end

    tests("#get_cloud_ip").raises(ArgumentError) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_cloud_ip
    end

  end


end
