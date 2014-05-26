Shindo.tests("Fog::Compute::HPV2 | server security group requests", ['hp', 'v2', 'compute']) do

  service = Fog::Compute.new(:provider => 'HP', :version => :v2)

  @base_image_id = ENV['BASE_IMAGE_ID'] || '7f60b54c-cd15-433f-8bed-00acbcd25a17'

  tests('success') do

    @server_name = 'fogsecgrouptests'
    @server_id = nil

    # create a server without a sec group
    data = service.create_server(@server_name, 100, @base_image_id).body['server']
    @server_id = data['id']

    # now add the 'default' sec group to the server
    tests("#add_security_group(#{@server_id}, 'default')").succeeds do
      service.add_security_group(@server_id, 'default')
    end

    # now remove the 'default' sec group to the server
    tests("#remove_security_group(#{@server_id}, 'default')").succeeds do
      service.remove_security_group(@server_id, 'default')
    end

    service.delete_server(@server_id)

  end

  tests('failure') do

    tests("#add_security_group(0, 'default')").raises(Fog::Compute::HPV2::NotFound) do
      service.add_security_group(0, 'default')
    end

    tests("#remove_security_group(0, 'default')").raises(Fog::Compute::HPV2::NotFound) do
      service.remove_security_group(0, 'default')
    end

  end

end
