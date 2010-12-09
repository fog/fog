Shindo.tests('Brightbox::Compute | cloud ip requests', ['brightbox']) do

  tests('success') do

    tests("#create_cloud_ip()").formats(Brightbox::Compute::Formats::Full::CLOUD_IP) do
      data = Brightbox[:compute].create_cloud_ip()
      @cloud_ip_id = data["id"]
      data
    end

    tests("#list_cloud_ips()").formats(Brightbox::Compute::Formats::Collection::CLOUD_IPS) do
      Brightbox[:compute].list_cloud_ips()
    end

    tests("#get_cloud_ip('#{@cloud_ip_id}')").formats(Brightbox::Compute::Formats::Full::CLOUD_IP) do
      Brightbox[:compute].get_cloud_ip(@cloud_ip_id)
    end

    server = Brightbox[:compute].servers.first
    interface_id = server.interfaces.first["id"]
    map_options = {:interface => interface_id}
    tests("#map_cloud_ip('#{@cloud_ip_id}', #{map_options.inspect})").formats(Brightbox::Compute::Formats::Full::CLOUD_IP) do
      Brightbox[:compute].map_cloud_ip(@cloud_ip_id, map_options)
    end

    Brightbox[:compute].cloud_ips.get(@cloud_ip_id).wait_for { mapped? }

    tests("#unmap_cloud_ip('#{@cloud_ip_id}')").formats(Brightbox::Compute::Formats::Full::CLOUD_IP) do
      Brightbox[:compute].unmap_cloud_ip(@cloud_ip_id)
    end

    tests("#destroy_cloud_ip('#{@cloud_ip_id}')").formats(Brightbox::Compute::Formats::Full::CLOUD_IP) do
      Brightbox[:compute].destroy_cloud_ip(@cloud_ip_id)
    end

  end

  tests('failure') do

    tests("#get_cloud_ip('cip-00000')").raises(Excon::Errors::NotFound) do
      Brightbox[:compute].get_cloud_ip('cip-00000')
    end

    tests("#get_cloud_ip()").raises(ArgumentError) do
      Brightbox[:compute].get_cloud_ip()
    end
  end

end
