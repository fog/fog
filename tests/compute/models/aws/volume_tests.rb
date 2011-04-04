Shindo.tests("AWS::Compute | volume", ['aws']) do

  @server = AWS[:compute].servers.create(:image_id => GENTOO_AMI)
  @server.wait_for { ready? }

  model_tests(AWS[:compute].volumes, {:availability_zone => @server.availability_zone, :size => 1, :device => '/dev/sdz1'}, true) do

    @instance.wait_for { ready? }
                      
    tests('#server = @server').succeeds do
      @instance.server = @server
    end

    @instance.wait_for { state == 'in-use' }

    tests('#server = nil').succeeds do
      @instance.server = nil
    end

    @instance.wait_for { ready? }

  end

  @server.destroy

end