Shindo.tests("Fog::Compute::HPV2 | server model", ['hp', 'v2', 'compute']) do

  service = Fog::Compute.new(:provider => 'HP', :version => :v2)

  @base_image_id = ENV['BASE_IMAGE_ID'] || '7f60b54c-cd15-433f-8bed-00acbcd25a17'

  model_tests(service.servers, {:name => 'fogservertest', :flavor_id => 100, :image_id => @base_image_id}, true) do

    @server = service.servers.create(:name => 'fogservertest', :flavor_id => 100, :image_id => @base_image_id)

    tests('#console_output(10)') do
      @server.console_output(10)
    end

    tests('#vnc_console_url') do
      @server.vnc_console_url
    end

    tests("#create_image('fogimgfromserver')") do
      @server.create_image('fogimgfromserver')
    end

    tests("#reboot('SOFT')") do
      pending unless Fog.mocking?
      @server.reboot('SOFT')
    end

    tests("#rebuild(#{@base_image_id}, 'fogrebuildserver')") do
      pending
      @server.rebuild(@base_image_id, 'fogrebuildserver')
    end

  end

end
