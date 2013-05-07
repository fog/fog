Shindo.tests("Fog::Compute::HPV2 | address model", ['hp', 'v2', 'compute']) do

  service = Fog::Compute.new(:provider => 'HP', :version => :v2)

  @base_image_id = ENV['BASE_IMAGE_ID'] || '7f60b54c-cd15-433f-8bed-00acbcd25a17'

  model_tests(service.addresses, {}, true) do

    @server = service.servers.create(:name => 'fogseraddtests', :flavor_id => 100, :image_id => @base_image_id)
    @server.wait_for { ready? }

    tests('#server=').succeeds do
      @instance.server = @server
      test('server attached') do
        @instance.instance_id == @server.id
      end
    end

    @server.destroy

  end

end
