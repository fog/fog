Shindo.tests('Fog::Compute[:brightbox] | cloud ip requests', ['brightbox']) do

  tests('success') do

    unless Fog.mocking?
      @server = Brightbox::Compute::TestSupport.get_test_server
    end

    tests("#create_cloud_ip") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].create_cloud_ip
      @cloud_ip_id = result["id"]
      formats(Brightbox::Compute::Formats::Full::CLOUD_IP) { result }
    end

    tests("#list_cloud_ips") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].list_cloud_ips
      formats(Brightbox::Compute::Formats::Collection::CLOUD_IPS) { result }
    end

    tests("#get_cloud_ip('#{@cloud_ip_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].get_cloud_ip(@cloud_ip_id)
      formats(Brightbox::Compute::Formats::Full::CLOUD_IP) { result }
    end

    map_options = {:destination => @server.interfaces.first["id"]}
    tests("#map_cloud_ip('#{@cloud_ip_id}', #{map_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].map_cloud_ip(@cloud_ip_id, map_options)
      formats(Brightbox::Compute::Formats::Full::CLOUD_IP) { result }
    end

    unless Fog.mocking?
      Fog::Compute[:brightbox].cloud_ips.get(@cloud_ip_id).wait_for { mapped? }
    end

    tests("#unmap_cloud_ip('#{@cloud_ip_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].unmap_cloud_ip(@cloud_ip_id)
      formats(Brightbox::Compute::Formats::Full::CLOUD_IP) { result }
    end

    update_options = {:reverse_dns => "public.#{@server.id}.gb1.brightbox.com"}
    tests("#update_cloud_ip('#{@cloud_ip_id}', #{update_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].update_cloud_ip(@cloud_ip_id, update_options)
      formats(Brightbox::Compute::Formats::Full::CLOUD_IP) { result }
      result = Fog::Compute[:brightbox].update_cloud_ip(@cloud_ip_id, {:reverse_dns => ""})
    end

    tests("#destroy_cloud_ip('#{@cloud_ip_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].destroy_cloud_ip(@cloud_ip_id)
      formats(Brightbox::Compute::Formats::Full::CLOUD_IP) { result }
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
